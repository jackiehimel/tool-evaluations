# E-OH-024 — E2b failing-test control record

Executed 2026-09-14T02:42–03:02Z under a single evaluator "go". Scoring is deliberately absent from this record; it awaits its own `JUDGMENT REQUIRED` gate (D-OH-29).

## Pre-flight (2026-09-14T02:41Z)

- Both automations `enabled = 0`, zero unfinished runs (automation DB, read-only).
- Cascade webhook inactive (GitHub API `"active": false`).
- PR #32 open, 1 commit, head `e4ca7369024ec862baa46c20b0bc1bdf520321c8`.
- Control checkout clean and detached at the PR head; remote URL plain HTTPS with no embedded credential; git identity is the evaluator's own (evaluator-authored control as required; identity redacted from evidence per the scrub list).

## Injection

- One new file only: `tests/eval-control-failing.test.ts`, a self-labeled deliberately failing vitest case asserting an incorrect result from `formatChangelogDate`. Diff preserved as E-OH-019.
- Local suite run before pushing (E-OH-020): exit code 1, `Tests 1 failed | 87 passed (88)`, failure exactly and only in the injected file. Local run 2026-09-14T02:42:54–02:42:55Z.
- Control commit `c3c47f803aa8517f46f8c8e7f4771c0e2e126207`, created with `git commit-tree` (author = evaluator, redacted; verified free of tool attribution trailers), parent `e4ca7369`.
- Pushed 2026-09-14T02:43:14Z.

## Observed CI result (E-OH-021)

- GitHub workflow run `34800151622`, check `Lint, typecheck, test, build`: **failure**, started 02:43:23Z, completed 02:44:09Z.
- Failed-job log shows the injected test as the sole failure: `Tests 1 failed | 87 passed (88)`, `AssertionError: expected '2026-08-07' to be 'CONTROL-EXPECTED-FAILURE'`.
- `Vercel Preview Comments` check: success. (The Vercel deployment check behavior on this branch was already recorded at E2; see E-OH-012.)

## Attribution note (per D-OH-30)

This CI failure is evidence that **GitHub CI** caught the failing test. No OpenHands component observed or reported it: both automations were disabled throughout, and the pinned extensions catalog has no automatic failed-CI responder (its `github-repo-monitor` is an `@OpenHands` mention poller). The absence of an OpenHands-produced report is negative evidence for the corresponding matrix row.

## Revert

- Revert commit `05d2dfc90514bcaf0208ab6966799e65ac5f5cc0` created with `git commit-tree` using the tree object of `e4ca7369` directly; verified `HEAD^{tree}` identical to the pre-control tree (byte-for-byte restoration). Diff preserved as E-OH-022. Attribution scan clean; author = evaluator (redacted).
- Pushed 2026-09-14T02:59:48Z.
- Post-revert checks (E-OH-023): `Lint, typecheck, test, build` **success** (completed 2026-09-14T03:02Z window), `Vercel Preview Comments` success.
- PR #32 final state: open, draft, 3 commits, head `05d2dfc9`, mergeable state clean, feature content unchanged from `e4ca7369`.

## Post-control state

- Both automations remain disabled; Cascade webhook remains inactive; no OpenHands conversation was created during the control (the automation DB run count is unchanged).
- The `openhands-review` label remains applied and was not re-consumed (reviewer automation disabled).
