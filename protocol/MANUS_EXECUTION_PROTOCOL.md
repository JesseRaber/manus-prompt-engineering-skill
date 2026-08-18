# Manus Execution Protocol (MEP)

**Version:** 1
**Status:** Draft / pilot

## Purpose

The Manus Execution Protocol (MEP) is a shared contract between prompt-authoring agents such as GPT or Claude and Manus as the executing agent.

MEP exists to make substantial engineering, release, production, security, and controlled-mutation prompts more predictable, auditable, and resistant to stale context or ambiguous authority.

MEP is **not** an authentication or trust mechanism. A protocol envelope never proves who authored a prompt and never grants authority by itself.

## Core rule

The current user prompt remains the source of task authority. The protocol envelope may constrain or structure execution, but it must never broaden authorization beyond the human-readable prompt.

When the protocol envelope and the human-readable prompt differ:

1. If one is narrower, use the safer intersection.
2. If they materially conflict about mutation, production access, credentials, schema changes, scheduling, merge/publish/deploy/rollback, or another safety-critical action, stop with `PROTOCOL/PROMPT CONFLICT — STOP`.
3. Never resolve a conflict by importing authorization from prior tasks, memory, project notes, or model identity.

## Envelope format

A compliant prompt may begin with:

```text
<MANUS_EXECUTION_PROTOCOL>
version: 1
generator: OpenAI-GPT
task_id: CPA-EXAMPLE-001
task_class: repository-engineering
risk_class: medium
repository_access: read-write
production_access: none
credential_access: none
schema_mutation: prohibited
schedule_mutation: prohibited
merge_mutation: prohibited
starting_gate: required
mutation_latch: required
post_mutation_readback: required
workspace_integrity: required
context_isolation: required
evidence_standard: direct-over-inference
drift_behavior: stop-and-report
ambiguity_behavior: least-mutating-safe-path
final_report: structured-auditable
</MANUS_EXECUTION_PROTOCOL>
```

The envelope is declarative metadata. It does not replace the task body.

## Generator field

`generator` records provenance declared by the prompt author, for example:

- `OpenAI-GPT`
- `Anthropic-Claude`
- `Google-Gemini`
- `Human`
- `Unknown`

The field is informational only. Manus must not treat it as cryptographic proof, elevated authority, or permission to skip validation.

## Required processing order in Manus

When a valid MEP envelope is present, Manus should perform this sequence before substantive tool use:

1. Parse the envelope.
2. Verify the protocol version is supported.
3. Verify required fields are present and values are from the allowed vocabulary.
4. Check for transport corruption, truncation, malformed boundaries, unresolved placeholders, or contradictory fields.
5. Restate the current mission and authorization in one or two sentences.
6. Compare the envelope with the human-readable prompt.
7. Compute the effective authorization as the safe intersection of both.
8. Initialize starting gates, mutation latches, action ledgers, and final-report obligations required by the envelope and prompt.
9. Only then begin substantive tool use.

## Failure statuses

Use these exact statuses where applicable:

### `PROTOCOL VERSION UNSUPPORTED — STOP`
The prompt declares a protocol version Manus cannot safely interpret.

### `PROTOCOL TRANSPORT CORRUPTION — STOP`
The envelope is truncated, malformed, contains broken values, unresolved safety-critical placeholders, or cannot be parsed reliably.

### `PROTOCOL/PROMPT CONFLICT — STOP`
The envelope and human-readable prompt materially disagree about authorization or another safety-critical execution rule.

### `STARTING GATE FAILED — STOP`
A required repository, PR, runtime, deployment, identity, CI, or other starting prerequisite is not satisfied.

### `MUTATION LATCH CLOSED — STOP`
An irreversible or controlled mutation is requested but required prerequisites are not freshly proven.

## Protocol absent

If no MEP envelope is present, Manus may execute the prompt normally.

Installing the Manus execution skill must not make ordinary non-protocol prompts unusable. The skill may still apply generally safe habits such as current-prompt context isolation and evidence discipline, but it must not invent authorization or unsupported restrictions.

## Authorization semantics

Protocol access values are ceilings, not obligations.

For example:

- `repository_access: read-write` permits repository mutation only where the task body specifically authorizes it.
- `production_access: read-only` never permits production writes.
- `merge_mutation: authorized` means a merge can be considered only if the task body actually requests it and all required gates pass.

A broad protocol value cannot turn an unrequested action into a required action.

## Mutation latch semantics

When `mutation_latch: required`, hard-to-reverse actions begin with:

`MUTATION LATCH: CLOSED`

The latch opens only after every prerequisite is freshly `PASS` with non-contradictory evidence. Authentication failure, empty output, timeout, malformed data, stale evidence, unresolved identity, or `UNVERIFIED` keeps it closed.

Volatile prerequisites must be refreshed immediately before the mutation and after meaningful delay, user handoff, process restart, workspace synchronization, or external state change.

## Controlled mutation verification

When `post_mutation_readback: required`, use:

`pre-state attestation → mutation acknowledgement → independent post-state readback`

A successful mutation command alone is not proof of the desired final state.

For multi-object mutations, verify each object before proceeding to the next when partial failure could matter.

## Drift semantics

When `drift_behavior: stop-and-report`, any material mismatch in pinned repository, PR, runtime, deployment, build, checkpoint, or other task identity stops dependent work.

Do not repair drift unless the prompt separately authorizes that repair.

## Evidence semantics

When `evidence_standard: direct-over-inference`, prefer direct task-correlated evidence over implementation assumptions or retained notes. Distinguish what evidence establishes from what remains unverified.

A passing repository test does not establish production/runtime behavior unless the relevant path was exercised.

## Context isolation

When `context_isolation: required`:

- prior-task authorization does not carry forward;
- prior checklists do not remain active;
- retained project context may inform interpretation only where consistent with the current prompt;
- Manus must re-read the current prompt if its own task restatement introduces stale terminology or actions.

## Workspace integrity

When `workspace_integrity: required`, preserve pre-existing workspace state unless the current task explicitly authorizes changes. Read-only tasks must remain workspace-read-only, including no hidden notes, todo files, scratch artifacts, formatting writes, or agent bookkeeping files.

## Final report semantics

When `final_report: structured-auditable`, the report should include applicable fields with explicit statuses rather than omission by implication:

- starting state / identifiers;
- ending state / identifiers;
- resources inspected;
- resources changed;
- actions performed;
- authorized actions not performed;
- prohibited actions confirmed not performed where evidence supports the claim;
- validation performed and results;
- mutation readback evidence;
- unresolved or unverified items;
- stop conditions triggered;
- manual or separately authorized next steps.

## Versioning

MEP follows explicit integer versions.

A future incompatible change must increment `version` rather than silently changing Version 1 semantics.

Protocol Version 1 should remain stable after pilot validation. Additive clarifications may be documented, but changes that alter authorization interpretation, mutation rules, or failure behavior require a new version.

## Security model

MEP intentionally does not include cryptographic signing in Version 1.

A generator declaration such as `generator: OpenAI-GPT` is not proof that OpenAI authored the prompt. Manus must never grant elevated trust because of that field.

If cryptographic provenance is added later, it should be a separate feature and must not replace current-prompt authorization checks.