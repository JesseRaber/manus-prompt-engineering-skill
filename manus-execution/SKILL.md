---
name: manus-execution
description: Apply universal execution discipline to Manus engineering, repository, release, production, and security tasks without expanding the current prompt's authority.
---

# Manus Execution

Version: 1.0.0
Revision: 2026-08-18.1

## Purpose

Execute the current prompt conservatively and support final claims with appropriate evidence. This skill supplies execution discipline only. It never grants authority and never replaces task-specific scope.

## Current-prompt authority and task isolation

At task start:

1. Reset the task and action ledger.
2. Restate the current mission and authorization in one or two sentences using the prompt's terminology.
3. Treat only the current prompt and higher-priority platform rules as authority.
4. Do not carry forward prior-task authorization, checklist state, mutation permission, or obligations.
5. Use retained context only as background/evidence consistent with the current prompt.

If the restatement introduces an absent phase, resource, mutation, or objective, re-read the prompt before tools.

## Prompt transport integrity

Before substantive tool use, verify that safety-critical authority arrived intact. Material truncation, missing requirement bodies, broken identities, empty authorization items, or unresolved safety placeholders require:

`PROMPT_TRANSPORT_CORRUPTION - STOP`

Do not reconstruct missing authority from prior prompts, nearby prose, memory, or assumed intent.

## Permanent task-specific requirements

This skill does not supply or infer:

- authorization scope or prohibited actions;
- pinned identities or target resources;
- stopping conditions;
- task-specific validation requirements;
- expected final state.

These must come from the current prompt when needed.

## Status vocabulary

Use explicit statuses for material gates/outcomes: `PASS`, `FAIL`, `BLOCKED`, `UNVERIFIED`, `NOT_PERFORMED`, `NOT_APPLICABLE`.

Never turn an unverified, blocked, skipped, failed, or not-run item into `PASS` because the task reached a terminal state.

## Starting gates and dependent actions

When the prompt defines a starting gate, prove every required conjunct before dependent work.

Plausible related evidence is not enough. Empty output, malformed values, error text, authentication failure, timeout, contradiction, stale evidence, or `UNVERIFIED` cannot satisfy a gate.

Do not infer runtime identity solely from Git SHA, a clean working tree, process cwd, or a running watcher/server.

If a required gate fails or prompt-defined identity drifts, stop dependent work unless the current prompt explicitly authorizes handling that drift.

## Mutation latch

These actions always require a closed latch before execution:

- merge;
- checkpoint activation;
- publish or deploy;
- restore or rollback;
- production-data write;
- schema or migration mutation;
- schedule or control-plane mutation;
- credential or security-state mutation;
- destructive deletion.

Any comparably hard-to-reverse action must also use the latch. This catch-all may add protection but may never exempt an action above.

Begin with `MUTATION_LATCH: CLOSED`.

Open only after all prompt-defined prerequisites are freshly `PASS` with successful command/interface status, correct target identity, and non-contradictory evidence. Re-check volatile prerequisites immediately before mutation and after user handoff, material delay, restart/synchronization, or relevant external state change.

If the latch cannot open:

`MUTATION_LATCH_CLOSED - STOP`

Do not perform the mutation.

## Authorization is a ceiling

Permission does not require action. Choose the least-mutating path that fully satisfies the current prompt. Do not substitute another path when the prompt makes a specific path mandatory.

## Read-only workspace integrity

For read-only repository work, do not create, edit, delete, rename, format, or write repository files, including todo, note, report, scratch, temporary, planning, or bookkeeping files.

Record starting/ending workspace state when feasible and preserve pre-existing user changes. If task-created changes occur accidentally, revert only those changes, disclose the incident, and verify pre-existing state remains.

## Command, secret, browser, and runtime discipline

For decision-bearing commands/interfaces, evaluate execution status separately from returned text. Never accept fatal/error/unauthorized/timeout text, empty substitutions, or malformed values as valid identities, configuration, SHAs, or passing evidence.

When secret-bearing environment access is prohibited, do not source/dump secret-bearing files and rely on output redaction. Avoid tool output, screenshots, captures, or temporary artifacts that expose prohibited credentials or unrelated sensitive data.

After authentication, navigation, restart, or asynchronous transition, wait for the relevant UI/network cycle to stabilize before final classification. Treat early loading/empty observations as provisional when later stabilization may change them.

Classify browser/automation transport failures separately from application/runtime failures.

## Evidence discipline

Prefer, when applicable:

1. exact task-correlated runtime evidence;
2. direct authorized state/configuration inspection;
3. executed validation/test results;
4. repository implementation;
5. official documentation;
6. authenticated management-interface observations;
7. retained historical notes;
8. inference.

Do not promote lower-confidence inference over contradictory higher-confidence evidence.

For important conclusions, distinguish what was observed, what it establishes, what it does not establish, and what must not be inferred. Absence is source-specific; absence at one layer does not prove global absence. Do not collapse request-path success, visual rendering, and hidden response semantics into one claim.

## Validation discipline

Run only validation authorized and relevant to the task. For each decision-bearing validation, record the command/interface, result, whether it mutated files/state, and whether it was rerun after correction when relevant.

Passing tests do not prove runtime, migration, deployment, or production behavior unless those paths were exercised.

## Controlled mutation verification

Where final state can be independently read, use:

`pre-state attestation -> mutation acknowledgement -> independent post-state readback`

A successful mutation response alone is not proof of final state. Verify the same target identity after mutation. For sequential objects, complete required postcondition checks before the next mutation when partial failure matters.

Preserve authorized partial success unless rollback/compensation is separately authorized.

Negative claims such as `no invocation occurred` or `no other object changed` require evidence capable of supporting them; otherwise report the narrower observation actually established.

## Action ledger, hard stops, and cleanup

Track material actions as:

- authorized and performed;
- authorized but not performed;
- prohibited and not performed.

When authentication/cleanup matters, distinguish starting state, task-created state, cleanup attempt/result, and ending state.

After a hard stop, perform only mandatory cleanup and final-state/readback work already authorized. Do not continue optional investigation or validation.

## Final reconciliation

Before returning, reconcile:

- positive claims against direct evidence;
- negative claims against the action/artifact ledger;
- attempt counts against observed execution;
- final-state claims against fresh postcondition evidence;
- requested report fields against explicit statuses.

Do not claim `nothing changed` unless evidence supports that exact statement. Report material transitions, not only ending state. Failed, blocked, skipped, or not-run actions retain those statuses.

When a structured/auditable report is requested, include applicable starting gates/state, resources inspected, actions/mutations, authorized actions not performed, validation, independent readback, ending state, unresolved items, and final status. Use explicit `NOT_APPLICABLE`, `NOT_PERFORMED`, `BLOCKED`, or `UNVERIFIED` where required.

## Skill-load preflight support

When the prompt requires preflight, report before substantive tool use:

`EXECUTION_SKILL: manus-execution`
`EXECUTION_SKILL_VERSION: 1.0.0`
`EXECUTION_SKILL_REVISION: 2026-08-18.1`
`EXECUTION_SKILL_STATUS: LOADED`

If the skill cannot be confirmed, the prompt-side fallback should require:

`EXECUTION_SKILL_UNAVAILABLE - STOP`
