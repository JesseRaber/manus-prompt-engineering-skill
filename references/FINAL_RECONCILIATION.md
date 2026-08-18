# Final Reconciliation

Run this mechanical comparison before returning a report.

## Positive claims

Map every positive claim to a fresh `PASS` evidence row. If a requested field was not collected, report `UNVERIFIED` or `PARTIAL`; do not omit it.

## Negative claims

Compare each `no X occurred` statement against:

- command/action ledger;
- retries and failed attempts;
- browser interactions;
- platform readback/audit;
- artifact ledger;
- authorized side effects and incidents.

If absence was sampled rather than exhaustive, use `not observed`.

## Material transitions

List the path, not merely the ending state:

- dirty → clean workspace;
- open PR → merged main;
- requested sync → claimed success → SHA mismatch;
- old live → candidate live;
- enabled → paused object;
- loading → timeout.

Unexplained transitions remain incidents even when the ending state looks safe.

## Attempt counts

Count failed and successful attempts separately. A parse-rejected SQL statement followed by a successful retry is two read-only attempts.

## Final platform state

Use a fresh post-action readback. If only pre-action evidence exists, say `last confirmed before [event]`; do not claim the state remained current.

Reconcile separate state planes. `git status` supports working-tree claims, not unchanged `.git/config`, credential helpers, refs, `FETCH_HEAD`, branch/HEAD/index, or external platform state. List authorized Git-administrative transitions and their final disposition explicitly.

## Unauthorized-action closure

Say `no unauthorized action occurred` only when the ledger contains no:

- gate bypass;
- prohibited access;
- interface substitution;
- scope expansion;
- execution-surface exposure;
- unapproved artifact creation;
- unreported mutation.

Otherwise include `Incidents and deviations` and state each effect precisely.

## Progress-state integrity

Ensure task items use the real state:

```text
PASS | FAIL | PENDING | TIMEOUT | BLOCKED | NOT RUN | SKIPPED | UNVERIFIED | PARTIAL | NOT APPLICABLE
```

Reaching a terminal conclusion about an action does not mean the action itself ran.
