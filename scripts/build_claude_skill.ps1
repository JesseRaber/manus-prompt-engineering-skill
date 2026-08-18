[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$OutputPath
)

$ErrorActionPreference = 'Stop'

$skillRoot = Split-Path -Parent $PSScriptRoot
$skillFile = Join-Path $skillRoot 'SKILL.md'
$skillText = Get-Content -LiteralPath $skillFile -Raw
$frontmatter = [regex]::Match(
    $skillText,
    '^---\r?\n(?<body>.*?)\r?\n---',
    [System.Text.RegularExpressions.RegexOptions]::Singleline
)

if (-not $frontmatter.Success) {
    throw 'SKILL.md does not contain valid frontmatter delimiters.'
}

$frontmatterBody = $frontmatter.Groups['body'].Value
$name = [regex]::Match($frontmatterBody, '(?m)^name:\s*(?<value>.+)$').Groups['value'].Value.Trim()
$description = [regex]::Match($frontmatterBody, '(?m)^description:\s*(?<value>.+)$').Groups['value'].Value.Trim()

if ($name -notmatch '^[a-z0-9]+(?:-[a-z0-9]+)*$' -or $name.Length -gt 64) {
    throw "Invalid skill name: $name"
}

if ([string]::IsNullOrWhiteSpace($description) -or $description.Length -gt 200) {
    throw "Claude.ai requires a non-empty description of at most 200 characters; found $($description.Length)."
}

$skillLineCount = (Get-Content -LiteralPath $skillFile).Count
if ($skillLineCount -gt 500) {
    throw "SKILL.md must remain at or below 500 lines; found $skillLineCount."
}

$contentRoots = @('references', 'templates', 'examples')
$contentFiles = @('SKILL.md')
foreach ($contentRoot in $contentRoots) {
    $contentRootPath = Join-Path $skillRoot $contentRoot
    if (Test-Path -LiteralPath $contentRootPath) {
        $contentFiles += Get-ChildItem -LiteralPath $contentRootPath -Recurse -File -Filter '*.md' |
            ForEach-Object { $_.FullName.Substring($skillRoot.Length + 1).Replace('\', '/') }
    }
}

$contentFiles = @($contentFiles | Sort-Object -Unique)
$edges = @{}
foreach ($relativePath in $contentFiles) {
    $absolutePath = Join-Path $skillRoot $relativePath
    $text = Get-Content -LiteralPath $absolutePath -Raw
    $edges[$relativePath] = @(
        [regex]::Matches($text, '(?:references|templates|examples)/[A-Za-z0-9_.-]+\.md') |
            ForEach-Object { $_.Value } |
            Sort-Object -Unique
    )

    foreach ($target in $edges[$relativePath]) {
        if ($contentFiles -notcontains $target) {
            throw "Broken skill resource reference in ${relativePath}: $target"
        }
    }
}

$reachable = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
$queue = [System.Collections.Generic.Queue[string]]::new()
$queue.Enqueue('SKILL.md')
while ($queue.Count -gt 0) {
    $current = $queue.Dequeue()
    if (-not $reachable.Add($current)) {
        continue
    }

    foreach ($target in $edges[$current]) {
        $queue.Enqueue($target)
    }
}

$orphans = @($contentFiles | Where-Object { -not $reachable.Contains($_) })
if ($orphans.Count -gt 0) {
    throw "Unreachable skill resources: $($orphans -join ', ')"
}

$resolvedOutput = [System.IO.Path]::GetFullPath($OutputPath)
if (Test-Path -LiteralPath $resolvedOutput) {
    throw "Output already exists: $resolvedOutput"
}

$outputDirectory = Split-Path -Parent $resolvedOutput
if (-not (Test-Path -LiteralPath $outputDirectory)) {
    New-Item -ItemType Directory -Path $outputDirectory | Out-Null
}

$stagingRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("manus-skill-package-" + [guid]::NewGuid().ToString('N'))
$packageRoot = Join-Path $stagingRoot $name

try {
    New-Item -ItemType Directory -Path $packageRoot | Out-Null
    Copy-Item -LiteralPath $skillFile -Destination (Join-Path $packageRoot 'SKILL.md')

    foreach ($contentRoot in $contentRoots) {
        $source = Join-Path $skillRoot $contentRoot
        if (Test-Path -LiteralPath $source) {
            Copy-Item -LiteralPath $source -Destination $packageRoot -Recurse
        }
    }

    Compress-Archive -LiteralPath $packageRoot -DestinationPath $resolvedOutput

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $archive = [System.IO.Compression.ZipFile]::OpenRead($resolvedOutput)
    try {
        $entries = @($archive.Entries | ForEach-Object { $_.FullName.Replace('\', '/') })
        if ($entries -notcontains "$name/SKILL.md") {
            throw 'Package does not contain the required rooted SKILL.md entry.'
        }

        $unexpectedRoots = @(
            $entries |
                Where-Object { $_ -ne '' } |
                ForEach-Object { ($_ -split '/')[0] } |
                Where-Object { $_ -ne $name } |
                Sort-Object -Unique
        )
        if ($unexpectedRoots.Count -gt 0) {
            throw "Package contains unexpected root entries: $($unexpectedRoots -join ', ')"
        }
    }
    finally {
        $archive.Dispose()
    }

    $hash = Get-FileHash -LiteralPath $resolvedOutput -Algorithm SHA256
    [pscustomobject]@{
        name = $name
        description_length = $description.Length
        skill_lines = $skillLineCount
        reachable_content_files = $reachable.Count
        package = $resolvedOutput
        sha256 = $hash.Hash.ToLowerInvariant()
    }
}
finally {
    if (Test-Path -LiteralPath $stagingRoot) {
        Remove-Item -LiteralPath $stagingRoot -Recurse -Force
    }
}
