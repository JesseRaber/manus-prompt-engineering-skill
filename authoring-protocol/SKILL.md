---
name: manus-protocol-authoring
description: Add a valid Manus Execution Protocol v1 envelope when writing substantial Manus engineering, release, production, security, or controlled-mutation prompts. Use with the manus-prompt-engineering skill.
---

# Manus Protocol Authoring

## Purpose

Generate a valid Manus Execution Protocol (MEP) Version 1 envelope that matches the human-readable Manus prompt and never expands user authority.

Use this companion with the repository's main `manus-prompt-engineering` skill. The main skill governs prompt quality; this companion governs the machine-readable execution envelope.

Read:

- `../protocol/MANUS_EXECUTION_PROTOCOL.md`
- `../protocol/PROTOCOL_SCHEMA.md`
- `../protocol/ENVELOPE_TEMPLATE.md`
- `../protocol/EXAMPLES.md`

## When to emit MEP

Emit a Version 1 envelope for substantial Manus tasks involving one or more of:

- repository inspection or edits;
- pull-request validation;
- release planning/execution;
- production diagnosis or access;
- credentials/session handling;
- schedule/control-plane mutation;
- schema/migrations;
- deploy/publish/restore/rollback;
- deletion or other controlled mutation;
- security-sensitive investigation.

For trivial conversational prompts, a protocol envelope is unnecessary.

## Authoring sequence

1. Determine the user's actual requested outcome.
2. Determine the minimum access and mutation classes needed.
3. Build the envelope from the Version 1 controlled vocabulary.
4. Prefer the narrower/safer value when the task does not need broader access.
5. Treat every `authorized` mutation field as a ceiling, not an instruction to mutate.
6. Write the normal human-readable task body using the main Manus Prompt Engineering skill.
7. Reconcile the envelope against the final rendered prompt.
8. If the envelope and prompt conflict, fix the authoring error before returning the prompt.
9. Remove all unresolved placeholders from safety-critical fields.

## Generator declaration

Set `generator` to the model/environment actually producing the prompt when known, for example:

- `OpenAI-GPT`
- `Anthropic-Claude`
- `Google-Gemini`
- `Human`

This is provenance only. Never describe it as a cryptographic signature or source of authority.

## Access selection

Use the minimum sufficient ceiling:

- repository inspection only => `repository_access: read-only`
- authorized repository edits => `repository_access: read-write`
- no production contact => `production_access: none`
- production diagnostics only => `production_access: read-only`
- exact authorized production mutation => `production_access: read-write`

Do the same for credentials, schema, schedules, and merge.

## Mutation defaults

Unless the task specifically needs them, default to:

- `schema_mutation: prohibited`
- `schedule_mutation: prohibited`
- `merge_mutation: prohibited`

For hard-to-reverse actions use:

- `starting_gate: required`
- `mutation_latch: required`
- `post_mutation_readback: required`
- `context_isolation: required`
- `evidence_standard: direct-over-inference`
- `drift_behavior: stop-and-report`
- `final_report: structured-auditable`

## Read-only defaults

For serious read-only work prefer:

- `workspace_integrity: required`
- `context_isolation: required`
- `evidence_standard: direct-over-inference`
- `drift_behavior: stop-and-report` when identity matters
- `mutation_latch: not-required`
- mutation classes prohibited

## Conflict prevention

Before returning, check:

- Does the task body authorize anything the envelope prohibits?
- Does the envelope permit a mutation the task body never requests? This is allowed as a ceiling only when intentional, but prefer narrower values.
- Does `production_access` match every production action?
- Does `credential_access` match login/secret handling?
- Does `repository_access: read-only` coexist with any command likely to write files?
- Are merge/schema/schedule fields consistent with the task?
- Are all pinned identities and placeholders resolved?

The final prompt should never knowingly force Manus into `PROTOCOL/PROMPT CONFLICT — STOP`.

## Output placement

Place the complete protocol envelope near the top of the Manus prompt, before the mission and workstreams.

Do not hide protocol fields in prose.

## Quality requirement

The envelope is a compact execution contract, not a duplicate of the entire prompt. Keep task-specific details such as exact files, SHAs, resource IDs/aliases, validation commands, and expected final state in the human-readable prompt unless they are useful optional protocol fields.

## Final authoring check

A substantial MEP prompt is ready only when:

- Version 1 schema is valid;
- generator is provenance only;
- access values are minimum sufficient ceilings;
- prompt and envelope agree;
- irreversible actions are fail-closed;
- readback is required where acknowledgement is insufficient;
- stale prior-task authorization cannot carry forward;
- no safety-critical placeholders remain;
- the human-readable prompt remains independently understandable.