---
name: manus-execution-protocol
description: Enforce Manus Execution Protocol envelopes on substantial engineering, release, production, security, and controlled-mutation tasks. Use when a prompt contains <MANUS_EXECUTION_PROTOCOL> or when auditing protocol compliance.
---

# Manus Execution Protocol — Executor Skill

## Purpose

Interpret and enforce Version 1 Manus Execution Protocol (MEP) envelopes without expanding user authorization.

Read `../protocol/MANUS_EXECUTION_PROTOCOL.md` and `../protocol/PROTOCOL_SCHEMA.md` when an MEP envelope is present.

## Non-negotiable authority rule

The protocol does not authenticate the author and does not grant authority by itself.

The current human-readable prompt remains authoritative. Compute effective authorization as the safe intersection of:

1. the current prompt;
2. the protocol envelope;
3. higher-priority platform/system constraints.

Never import authorization from prior tasks, retained memory, model identity, project notes, or a `generator` declaration.

## Protocol preflight

Before substantive tool use when `<MANUS_EXECUTION_PROTOCOL>` is present:

1. Parse the envelope exactly.
2. Confirm `version: 1`.
3. Confirm every required field appears exactly once.
4. Validate each value against the Version 1 schema.
5. Reject duplicate keys, malformed boundaries, truncation, or unresolved safety-critical placeholders.
6. Restate the current mission and effective authorization in one or two sentences.
7. Compare envelope constraints with the human-readable prompt.
8. If one is narrower, use the narrower effective authorization.
9. If they materially conflict on safety-critical actions, return `PROTOCOL/PROMPT CONFLICT — STOP`.
10. Initialize required gates, latches, ledgers, and final-report obligations.

Do not begin repository, browser, runtime, production, or mutation work before this preflight completes.

## Exact stop states

Use these statuses when applicable:

- `PROTOCOL VERSION UNSUPPORTED — STOP`
- `PROTOCOL TRANSPORT CORRUPTION — STOP`
- `PROTOCOL/PROMPT CONFLICT — STOP`
- `STARTING GATE FAILED — STOP`
- `MUTATION LATCH CLOSED — STOP`

After a hard stop, perform only safe mandatory cleanup and final-state/readback work already authorized. Do not continue optional workstreams.

## Context isolation

When `context_isolation: required`:

- reset the task/execution ledger at the start;
- do not carry forward prior-task authorization;
- do not keep prior checklist items active;
- use retained context only as evidence or background consistent with the current prompt;
- if your mission restatement introduces stale task terminology or actions, re-read the current prompt before using tools.

## Starting gates

When `starting_gate: required`, prove each task-specific prerequisite before dependent actions.

Typical gates may include:

- repository identity;
- branch/PR identity;
- exact head/base SHA;
- working-tree state;
- exact-head CI;
- runtime/build/checkpoint/deployment identity;
- authenticated session state;
- target object identity.

A plausible related observation is not enough. Every conjunct must pass.

Empty output, fatal/error text, authentication failure, malformed values, timeout, contradictory evidence, or `UNVERIFIED` cannot satisfy a gate.

When `drift_behavior: stop-and-report`, material drift stops dependent work. Do not repair drift unless separately authorized.

## Mutation latch

When `mutation_latch: required`, controlled or hard-to-reverse actions start with:

`MUTATION LATCH: CLOSED`

Open the latch only after all prerequisites are freshly `PASS`.

Refresh volatile prerequisites immediately before the mutation and after:

- user takeover/login/confirmation;
- material delay;
- workspace restart or synchronization;
- process restart;
- external state change.

If the latch cannot open, do not mutate.

## Controlled mutations

When `post_mutation_readback: required`, use:

`pre-state attestation → mutation acknowledgement → independent post-state readback`

A success response from the mutation call is not sufficient proof.

For each controlled object, record where applicable:

- stable identity/alias;
- pre-state;
- mutation attempted;
- interface/command status;
- immediate post-state;
- independently reread post-state;
- unexpected collateral change;
- final status.

For sequential objects, verify one object's required postcondition before mutating the next when partial failure matters.

Preserve authorized partial success unless rollback/compensation is separately authorized.

## Workspace integrity

When `workspace_integrity: required`, preserve pre-existing user state.

For read-only repository tasks, do not create, edit, delete, rename, format, or write any repository file, including:

- todo files;
- notes;
- reports;
- scratch files;
- temporary artifacts;
- generated plans;
- agent bookkeeping files.

Record starting and ending workspace state when feasible. If task-created changes occur accidentally, revert only those task-created changes and disclose the incident.

## Access ceilings

Interpret access fields as ceilings, never obligations.

### Repository

- `none`: no repository access.
- `read-only`: inspect only; no repository writes.
- `read-write`: repository writes may occur only where the task body specifically authorizes them.

### Production

- `none`: no production access.
- `read-only`: production reads only; no writes/control-plane mutation.
- `read-write`: production mutation may be considered only where specifically authorized in the task body and all gates pass.

### Credentials

- `none`: do not access credentials.
- `metadata-only`: inspect non-secret credential/config metadata only.
- `user-handoff-only`: user may complete interactive identity confirmation; Manus must not type/copy secrets unless separately authorized.
- `authorized-secret-use`: secret use is possible only within the exact prompt-authorized surface and scope.

Never treat broad access as permission to explore unrelated surfaces.

## Special mutation fields

- `schema_mutation: prohibited` => no schema-changing migration or production schema alteration.
- `schedule_mutation: prohibited` => no schedule/task state changes.
- `merge_mutation: prohibited` => no merge.

If the task body requests an action prohibited by the envelope, stop on conflict.

If a field says `authorized`, the task body must still request and scope the action. Authorization is a ceiling, not a requirement.

## Evidence discipline

When `evidence_standard: direct-over-inference`, prefer:

1. exact task-correlated runtime evidence;
2. direct authorized state/config reads;
3. executed validation/test results;
4. repository implementation;
5. official documentation;
6. authenticated management-interface observations;
7. retained historical notes;
8. inference.

Separate:

- evidence;
- what it establishes;
- what it does not establish;
- prohibited inference.

Do not promote lower-confidence inference over contradictory higher-confidence evidence.

## Ambiguity

When `ambiguity_behavior: least-mutating-safe-path`, choose the least-mutating interpretation that fully satisfies the prompt.

When `ambiguity_behavior: stop-on-safety-critical-ambiguity`, stop rather than guess if ambiguity affects production writes, credentials, schema changes, scheduling, merge/publish/deploy/rollback, deletion, or another safety-critical action.

## Protocol absent

If no MEP envelope is present, execute normally.

Do not reject ordinary prompts merely because they lack the protocol.

You may still apply generally safe habits such as context isolation, evidence discipline, and accurate final reporting, but do not invent restrictions or pretend a missing protocol exists.

## Final report

When `final_report: structured-auditable`, explicitly report applicable fields:

- protocol version;
- declared generator;
- task ID/class/risk;
- effective authorization summary;
- starting gate results;
- starting state/identifiers;
- resources inspected;
- actions performed;
- mutations attempted;
- mutation latch transitions;
- independent post-mutation readback;
- resources changed;
- authorized actions not performed;
- prohibited actions not performed where supportable;
- validation and results;
- ending state/identifiers;
- unresolved/unverified items;
- stop status, if any;
- separately authorized/manual next steps.

Use `NOT APPLICABLE`, `NOT PERFORMED`, `BLOCKED`, or `UNVERIFIED` rather than silently omitting required fields.

Before returning, reconcile final claims against the action ledger and fresh postcondition evidence.

## Pilot rule

Version 1 is a pilot. Do not silently reinterpret unfamiliar fields. Unknown safety-critical fields or semantics require conservative handling and disclosure.