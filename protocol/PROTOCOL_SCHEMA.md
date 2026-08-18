# Manus Execution Protocol V1 — Schema

This document defines the controlled vocabulary for `<MANUS_EXECUTION_PROTOCOL>` Version 1.

## Required fields

Every Version 1 envelope must contain:

| Field | Allowed values / format | Meaning |
|---|---|---|
| `version` | `1` | Protocol version |
| `generator` | non-empty token/string | Declared authoring provenance only; not trusted identity |
| `task_id` | non-empty stable task label | Correlation identifier; not authority |
| `task_class` | controlled token | Broad work category |
| `risk_class` | `low`, `medium`, `high`, `critical` | Execution-risk classification |
| `repository_access` | `none`, `read-only`, `read-write` | Maximum repository access |
| `production_access` | `none`, `read-only`, `read-write` | Maximum production data/control-plane access |
| `credential_access` | `none`, `metadata-only`, `user-handoff-only`, `authorized-secret-use` | Maximum credential interaction |
| `schema_mutation` | `prohibited`, `authorized` | Whether schema-changing work may be considered |
| `schedule_mutation` | `prohibited`, `authorized` | Whether schedule/control-task changes may be considered |
| `merge_mutation` | `prohibited`, `authorized` | Whether merge may be considered |
| `starting_gate` | `required`, `optional` | Whether task-specific starting gates must be satisfied before dependent work |
| `mutation_latch` | `required`, `not-required` | Whether controlled/irreversible mutations use a fail-closed latch |
| `post_mutation_readback` | `required`, `recommended`, `not-required` | Independent verification requirement after mutations |
| `workspace_integrity` | `required`, `normal` | Whether pre-existing workspace state must be explicitly attested/preserved |
| `context_isolation` | `required`, `normal` | Whether prior-task state must be explicitly excluded |
| `evidence_standard` | `direct-over-inference`, `normal` | Evidence-discipline mode |
| `drift_behavior` | `stop-and-report`, `report-and-continue-if-safe` | Handling of material state drift |
| `ambiguity_behavior` | `least-mutating-safe-path`, `stop-on-safety-critical-ambiguity` | Ambiguity policy |
| `final_report` | `structured-auditable`, `normal` | Final-report obligation |

## Recommended task classes

Use one of these when it fits:

- `read-only-audit`
- `repository-engineering`
- `documentation-reconciliation`
- `pull-request-validation`
- `release-planning`
- `release-execution`
- `production-diagnosis`
- `controlled-platform-mutation`
- `schema-migration`
- `security-investigation`
- `runtime-validation`
- `capability-assessment`
- `other`

`task_class` helps Manus choose an execution pattern. It does not grant permissions.

## Effective-authorization calculation

Manus must treat each protocol authorization value as a ceiling and then intersect it with the human-readable prompt.

Examples:

- Protocol `repository_access: read-write` + prompt says `read-only` => effective repository access is read-only.
- Protocol `production_access: read-only` + prompt requests a production UPDATE => material conflict; stop.
- Protocol `merge_mutation: authorized` + prompt asks only for PR review => merge remains unrequested and must not occur.
- Protocol `merge_mutation: prohibited` + prompt explicitly says merge => material conflict; stop.

## Safety-critical conflict fields

A contradiction involving any of these fields is material by default:

- `repository_access`
- `production_access`
- `credential_access`
- `schema_mutation`
- `schedule_mutation`
- `merge_mutation`
- `mutation_latch`
- `post_mutation_readback`
- `drift_behavior`

Use `PROTOCOL/PROMPT CONFLICT — STOP` rather than guessing.

## Optional extension fields

Version 1 permits optional fields when their meaning is obvious and they do not contradict required fields. Recommended optional fields include:

- `repository`
- `pr_number`
- `expected_head_sha`
- `expected_base_sha`
- `runtime_identity_required`
- `production_write_scope`
- `authorized_resources`
- `prohibited_resources`
- `required_validation`
- `expected_final_state`

Unknown optional fields must not silently grant authorization.

If an unknown field appears to affect safety-critical authorization, classify the envelope as unsupported/ambiguous and stop.

## Syntax rules

1. Envelope begins with exactly `<MANUS_EXECUTION_PROTOCOL>`.
2. Envelope ends with exactly `</MANUS_EXECUTION_PROTOCOL>`.
3. One `key: value` pair per line.
4. Duplicate keys are invalid.
5. Required fields must appear exactly once.
6. Values must not be inferred from nearby prose when absent.
7. Unresolved placeholders such as `[SHA]`, `<TOKEN>`, `TODO`, or `TBD` in safety-critical fields are invalid unless the prompt explicitly defines them as non-authoritative examples.
8. A truncated or malformed envelope requires `PROTOCOL TRANSPORT CORRUPTION — STOP`.

## Canonical read-only example

```text
<MANUS_EXECUTION_PROTOCOL>
version: 1
generator: Anthropic-Claude
task_id: EXAMPLE-READONLY-001
task_class: read-only-audit
risk_class: medium
repository_access: read-only
production_access: none
credential_access: none
schema_mutation: prohibited
schedule_mutation: prohibited
merge_mutation: prohibited
starting_gate: required
mutation_latch: not-required
post_mutation_readback: not-required
workspace_integrity: required
context_isolation: required
evidence_standard: direct-over-inference
drift_behavior: stop-and-report
ambiguity_behavior: least-mutating-safe-path
final_report: structured-auditable
</MANUS_EXECUTION_PROTOCOL>
```

## Canonical controlled-mutation example

```text
<MANUS_EXECUTION_PROTOCOL>
version: 1
generator: OpenAI-GPT
task_id: EXAMPLE-MUTATION-001
task_class: controlled-platform-mutation
risk_class: high
repository_access: read-only
production_access: read-write
credential_access: metadata-only
schema_mutation: prohibited
schedule_mutation: authorized
merge_mutation: prohibited
starting_gate: required
mutation_latch: required
post_mutation_readback: required
workspace_integrity: required
context_isolation: required
evidence_standard: direct-over-inference
drift_behavior: stop-and-report
ambiguity_behavior: stop-on-safety-critical-ambiguity
final_report: structured-auditable
</MANUS_EXECUTION_PROTOCOL>
```

The task body must still enumerate the exact schedule objects/actions authorized. The envelope alone does not authorize mutation.