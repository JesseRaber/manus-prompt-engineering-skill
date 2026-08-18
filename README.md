# Manus Prompt Engineering Skill

A reusable skill for designing and reviewing high-reliability prompts for Manus AI, especially engineering/repository/release tasks.

This package incorporates lessons from multiple recorded Manus executions, including hidden workspace writes, secret-bearing configuration reads, runtime/artifact provenance ambiguity, hard-gate ordering, authorization-vs-requirement ambiguity, session cleanup consistency, controlled process restarts, OAuth handoff boundaries, fenced request/log evidence, and prompt/final-response reconciliation.

It also includes fail-closed irreversible-action gates, prompt-render integrity checks, command-status validation, post-merge recovery topology, full execution-surface minimization, and mechanical final reconciliation.

The latest revision adds Claude.ai-compatible metadata, moves Cabinet Price Analyzer defaults into a conditional project profile, and provides a deterministic package builder that validates progressive disclosure and the ZIP root.

## Manus Execution Protocol V1

The repository now includes a draft/pilot two-sided execution protocol for GPT/Claude → Manus workflows.

The design intentionally does **not** use model identity as a trust signal. A declaration such as `generator: OpenAI-GPT` or `generator: Anthropic-Claude` records provenance only. It never grants authorization.

Protocol V1 uses a small `<MANUS_EXECUTION_PROTOCOL>` envelope that describes execution constraints such as repository/production access ceilings, controlled mutation classes, starting gates, mutation latches, independent post-mutation readback, drift handling, context isolation, and final-report requirements.

The current human-readable prompt remains authoritative. Manus computes effective authorization from the safe intersection of the prompt and protocol. Safety-critical conflicts stop rather than being guessed through.

Protocol files:

- `protocol/MANUS_EXECUTION_PROTOCOL.md` — canonical Version 1 semantics and failure behavior
- `protocol/PROTOCOL_SCHEMA.md` — required fields and controlled vocabulary
- `protocol/ENVELOPE_TEMPLATE.md` — authoring template
- `protocol/EXAMPLES.md` — pilot fixtures and conflict cases
- `authoring-protocol/SKILL.md` — GPT/Claude-side companion for emitting compliant envelopes
- `manus-execution/SKILL.md` — Manus-side companion for parsing and enforcing envelopes

### Recommended pilot installation

For GPT/Claude prompt authoring, use the existing `manus-prompt-engineering` skill together with `authoring-protocol/SKILL.md` and the `protocol/` references.

For Manus execution, use `manus-execution/SKILL.md` together with the `protocol/` reference files.

During the pilot, ordinary prompts without an MEP envelope remain valid; the Manus execution companion must not reject non-protocol prompts merely because the envelope is absent.

Do not treat Protocol V1 as cryptographically signed. If verifiable provenance is ever added, it should be a later, separate feature and must not replace current-prompt authorization checks.

### Packaging compatibility

The existing `scripts/build_claude_skill.ps1` continues to build and validate the original root `manus-prompt-engineering` package from `SKILL.md`, `references/`, `templates/`, and `examples/`.

The Protocol V1 pilot files intentionally live outside those validated content roots so the existing Claude package remains unchanged while the protocol is tested. The authoring and Manus executor companions should be installed/exposed separately during the pilot. A dedicated companion-package builder can be added after the protocol behavior is validated in real Manus runs.

## Package contents

- `SKILL.md` — main callable skill instructions
- `authoring-protocol/SKILL.md` — companion skill for GPT/Claude-side MEP V1 prompt envelopes
- `manus-execution/SKILL.md` — companion Manus-side MEP V1 executor
- `protocol/MANUS_EXECUTION_PROTOCOL.md` — canonical MEP V1 specification
- `protocol/PROTOCOL_SCHEMA.md` — MEP V1 schema and controlled vocabulary
- `protocol/ENVELOPE_TEMPLATE.md` — MEP V1 envelope authoring template
- `protocol/EXAMPLES.md` — MEP V1 pilot fixtures
- `references/READ_ONLY_WORKSPACE_INTEGRITY.md` — prevents hidden local writes during read-only work
- `references/EVIDENCE_AND_CAPABILITY_STATUS.md` — evidence hierarchy and layered status semantics
- `references/RUNTIME_PROVENANCE_AND_PREVIEW_FIDELITY.md` — distinguishes source, runtime, build, checkpoint, and deployment evidence
- `references/HARD_GATES_AND_RUNTIME_ATTESTATION.md` — prevents downstream testing before exact runtime prerequisites are proven
- `references/SECRET_PRESERVING_INSPECTION.md` — protects prohibited secrets during narrow configuration inspection
- `references/AUTHORIZATION_ACTION_LEDGER_AND_CLEANUP.md` — distinguishes permission from requirement and keeps login/logout/final claims consistent
- `references/SCREEN_RECORDING_REVIEW.md` — audits visible execution against prompt intent and final claims
- `references/CONTROLLED_PROCESS_RESTART_AND_AUTH_VALIDATION.md` — safe process replacement, OAuth boundaries, test-window fencing, and exception-aware reporting
- `references/VERSION_HISTORY_CHECKPOINT_PREVIEW.md` — UI-scoped Version History validation, asynchronous preview readiness, fresh-context proof, and rollback classification
- `references/TIMED_OBSERVATION_AND_EMBEDDED_INTERACTION.md` — timed state ledgers, deadline-based observations, embedded-browser recovery, and classification completeness
- `references/INTERACTION_RECOVERY_AND_MANUAL_HANDOFF.md` — ordered recovery ladders, user takeover, protected credential-entry phases, OAuth substep tracking, and actor attribution
- `references/RELEASE_AUTHORIZATION_PACKET.md` — evidence manifests, release executability states, callback transition proof, threshold provenance, and safe authorization templates
- `references/OPERATIONAL_CAPABILITY_INVESTIGATION.md` — negative-capability closure, CLI-vs-platform semantics, transition consistency, and orphan-window analysis
- `references/CONTROLLED_PLATFORM_MUTATION.md` — pre/post mutation proof, sequential partial-failure handling, audit-window watermarks, and execution-surface identifier hygiene
- `references/IRREVERSIBLE_RELEASE_GATE.md` — fail-closed merge/checkpoint/publish/rollback gates and post-merge recovery topology
- `references/EXECUTION_SURFACE_CONFIDENTIALITY.md` — output projection, authenticated-page minimization, URL/overlay incidents, and artifact handling
- `references/FINAL_RECONCILIATION.md` — positive/negative claim, attempt-count, state-transition, and final-readback checks
- `references/GIT_AUTHENTICATION_AND_WORKSPACE_SYNCHRONIZATION.md` — helper-chain inspection, residual configuration, fetch/sync gates, and separate Git state planes
- `references/ROLLBACK_ARTIFACT_IDENTITY.md` — rollback attempt ownership, source-fidelity rules, content-identity proof, and two-axis classification
- `references/PRODUCTION_DIAGNOSIS_AND_REPRODUCTION.md` — controlled UI reproduction, page-request correlation, causal branch gates, artifact limits, and diagnosis taxonomy
- `references/CABINET_PRICE_ANALYZER_PROFILE.md` — project-specific release defaults loaded only for Cabinet Price Analyzer work
- `templates/ENGINEERING_TASK_PROMPT.md` — general-purpose template
- `templates/READ_ONLY_CAPABILITY_ASSESSMENT.md` — security/platform capability template
- `templates/DOCUMENTATION_RECONCILIATION.md` — documentation-only reconciliation template
- `templates/READ_ONLY_PREVIEW_VALIDATION.md` — preview/rollback/runtime template
- `templates/CONTROLLED_LOCAL_PREVIEW_RESTART.md` — local dev-process restart plus authenticated validation template
- `templates/RELEASE_AUTHORIZATION_PACKET.md` — non-executing release-planning and conditional authorization template
- `templates/CONTROLLED_RELEASE_EXECUTION.md` — execution template with transport preflight, mutation latches, and residual-action handling
- `templates/SCREEN_RECORDING_REVIEW_REPORT.md` — report format that keeps functional result and authorization compliance separate
- `examples/CAPABILITY_ASSESSMENT_STATUS_EXAMPLE.md` — layered conclusion example
- `scripts/build_claude_skill.ps1` — validates Claude.ai limits and builds a correctly rooted upload ZIP

## Installation concept

Install/copy the entire `manus-prompt-engineering` directory into the skill directory used by the target agent environment. The callable entrypoint is `SKILL.md`.

For Protocol V1 pilots, additionally expose the authoring or executor companion entrypoint appropriate to the target model as described above.

To build the existing Claude.ai upload archive without GitHub's branch suffix, run:

```powershell
./scripts/build_claude_skill.ps1 -OutputPath /path/to/manus-prompt-engineering.zip
```

The command validates the Claude.ai description limit, the 500-line entrypoint guidance, all original resource links, transitive reachability, and the ZIP's single `manus-prompt-engineering/` root.
