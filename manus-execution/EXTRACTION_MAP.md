# Manus Execution Skill Extraction Map

Source: root `SKILL.md` on `main` at `44e68837554a0414f37f08b13183c743bb1e1a79`.

Inclusion rule for V1: a rule belongs in the execution core only when it is broadly applicable across projects and addresses either a known Manus failure mode or a necessary execution invariant.

Classifications:

- KEEP AS EXECUTION RULE - direct execution behavior with little semantic change.
- KEEP BUT REWRITE - important shared behavior currently written from an authoring perspective.
- AUTHORING-ONLY - DROP - prompt-construction guidance, not execution behavior.
- PROJECT-SPECIFIC - KEEP OUT - useful but not universal core behavior.
- DEFER FROM V1 - valid specialized behavior that would enlarge the pilot without being necessary to test the core.

| Existing section | Classification | V1 treatment | Estimated V1 lines |
|---|---|---|---:|
| Purpose | KEEP BUT REWRITE | Direct Manus operating purpose, current-prompt authority, accurate evidence-backed execution | 6 |
| Current-prompt restatement and context isolation | KEEP AS EXECUTION RULE | Reset task ledger; current prompt only; prior authorization never carries forward | 10 |
| Prompt transport integrity | KEEP AS EXECUTION RULE | Fail closed on truncation, missing authority, broken identities, unresolved safety placeholders | 8 |
| Default architecture | AUTHORING-ONLY - DROP | Remains authoring guidance | 0 |
| Starting gates | KEEP BUT REWRITE | Obey prompt-defined gates; prove every conjunct; stop on material drift | 10 |
| Irreversible-action mutation latch | KEEP AS EXECUTION RULE | Deterministic trigger list plus conservative one-way catch-all | 18 |
| Hard-gate closure before dependent actions | KEEP BUT REWRITE | No plausible-substitute evidence; runtime identity not inferred from checkout/process state | 10 |
| Authorization boundaries | AUTHORING-ONLY - DROP | Prompt must supply boundaries; executor enforces them | 0 |
| Authorization is a ceiling, not an obligation | KEEP AS EXECUTION RULE | Permission never creates an obligation; least-mutating path within explicit task requirements | 6 |
| Read-only means workspace-read-only | KEEP AS EXECUTION RULE | No hidden todo/scratch/report writes; preserve pre-existing state | 10 |
| Shell-command and process-control hard gates | KEEP BUT REWRITE | Keep command-status validation and secret-preserving command construction; defer detailed restart topology | 10 |
| Authentication handoff and incidental read footprint | DEFER FROM V1 | Specialized OAuth/session workflow | 0 |
| Browser stabilization and harness errors | KEEP BUT REWRITE | Stabilize before classification; separate harness/tool failures from app failures | 6 |
| Path evidence versus semantic evidence | KEEP BUT REWRITE | Do not infer hidden semantics from path/render success | 5 |
| Evidence discipline | KEEP AS EXECUTION RULE | Direct evidence over inference; separate what evidence proves from what it does not | 12 |
| Negative evidence is source-specific | KEEP BUT REWRITE | Absence at one layer does not prove global absence | 5 |
| Layered capability conclusions | DEFER FROM V1 | Useful specialized investigation vocabulary, not needed for universal core | 0 |
| Scope limiting | AUTHORING-ONLY - DROP | Prompt must define scope | 0 |
| Stopping conditions | KEEP BUT REWRITE | Obey prompt-defined stops; after hard stop perform only authorized mandatory cleanup/readback | 6 |
| Security-sensitive claims | KEEP BUT REWRITE | Never expose/use credentials outside explicit authority; qualify unsupported claims | 6 |
| Validation and formatting | KEEP BUT REWRITE | Record command result and mutation side effects; task-specific validation remains in prompt | 6 |
| Candidate evidence versus documentation-head evidence | DEFER FROM V1 | Release-specific provenance rule | 0 |
| Action ledger and cleanup consistency | KEEP AS EXECUTION RULE | Performed / authorized-not-performed / prohibited-not-performed; reconcile cleanup | 10 |
| Expected final state | AUTHORING-ONLY - DROP | Must remain task-specific prompt content | 0 |
| Final report | KEEP BUT REWRITE | Structured explicit statuses and mechanical claim reconciliation | 14 |
| Reviewing screen recordings | AUTHORING-ONLY - DROP | Review/audit guidance for GPT/Claude | 0 |
| Templates | AUTHORING-ONLY - DROP | Authoring package only | 0 |
| Controlled platform mutations | KEEP AS EXECUTION RULE | Pre-state -> acknowledgement -> independent readback; partial-success discipline | 12 |
| Operational capability closure | DEFER FROM V1 | Specialized capability investigation | 0 |
| Release authorization packets | AUTHORING-ONLY - DROP | Authoring/release planning | 0 |
| Executing an authorized release | KEEP BUT REWRITE | Generalize bypass/residual-authorization rule; do not keep release-specific prose | 6 |
| Quality gate before returning a Manus prompt | AUTHORING-ONLY - DROP | Authoring-only checklist | 0 |
| Project profiles | PROJECT-SPECIFIC - KEEP OUT | CPA remains outside universal executor core | 0 |

Estimated core before frontmatter/section spacing: about 176 lines. Compression should come from merging overlapping gate, evidence, mutation, and final-reconciliation rules, not from weakening semantics.

## Permanent non-goals

The execution skill must never replace these task-specific prompt elements:

1. authorization scope and prohibited actions;
2. pinned identities and target resources;
3. stopping conditions;
4. task-specific validation requirements;
5. expected final state.

## Pilot constraint

Do not modify the existing root authoring `SKILL.md` or authoring templates during the pilot. Shared execution rules will therefore be temporarily duplicated. The new execution skill README must record that debt explicitly. If Stage 3 passes, reconciliation to one canonical execution source becomes post-pilot work.
