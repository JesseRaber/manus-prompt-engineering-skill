# Manus Execution Protocol V1 Prompt Template

Use this envelope for substantial Manus engineering/release/security tasks when the Manus-side execution skill is installed.

Replace every placeholder before sending. Do not leave unresolved safety-critical placeholders.

```text
<MANUS_EXECUTION_PROTOCOL>
version: 1
generator: [OpenAI-GPT | Anthropic-Claude | Google-Gemini | Human | Other]
task_id: [STABLE-TASK-ID]
task_class: [TASK-CLASS]
risk_class: [low | medium | high | critical]
repository_access: [none | read-only | read-write]
production_access: [none | read-only | read-write]
credential_access: [none | metadata-only | user-handoff-only | authorized-secret-use]
schema_mutation: [prohibited | authorized]
schedule_mutation: [prohibited | authorized]
merge_mutation: [prohibited | authorized]
starting_gate: [required | optional]
mutation_latch: [required | not-required]
post_mutation_readback: [required | recommended | not-required]
workspace_integrity: [required | normal]
context_isolation: [required | normal]
evidence_standard: [direct-over-inference | normal]
drift_behavior: [stop-and-report | report-and-continue-if-safe]
ambiguity_behavior: [least-mutating-safe-path | stop-on-safety-critical-ambiguity]
final_report: [structured-auditable | normal]
</MANUS_EXECUTION_PROTOCOL>
```

Then write the normal human-readable task body.

## Authoring rules

1. The envelope must reflect the task body; do not use it to sneak in broader authority.
2. Prefer `prohibited` unless the task actually needs the mutation class.
3. `authorized` means the action may be considered only if the task body specifically requests and scopes it.
4. Use `mutation_latch: required` for merge, deploy, publish, restore, rollback, production writes, credential mutations, deletion, schedule changes, schema changes, and other hard-to-reverse actions.
5. Use `post_mutation_readback: required` whenever successful command acknowledgement is insufficient proof of final state.
6. Use `workspace_integrity: required` for read-only work and narrowly scoped repository edits where pre-existing state must be preserved.
7. Use `context_isolation: required` for multi-step projects, repeated Manus runs, or any workflow where stale prior-task state would be dangerous.
8. Use `drift_behavior: stop-and-report` when exact repo/PR/runtime/deployment identity matters.
9. Use `stop-on-safety-critical-ambiguity` when ambiguity could affect mutation scope or sensitive access.
10. Treat `generator` as provenance only, not a signature.

The protocol reduces repeated boilerplate but does not replace task-specific authorization.