# E-019 — Negative control A: a deliberately failing unit test (row 5 negative control, row 7b)

Branch `feature/changelog-data-feed` (PR #28), directive section 1 (D-28). Times UTC. Pushed under the evaluator's "go" of 2026-09-03T18:30 EDT.

## The control
Commit 1770fe2a "test(changelog): add same-agent ordering case", evaluator role identity, +15 lines in `tests/changelog.test.ts`: one new case asserting oldest-first for two updates of one agent, against the implemented newest-first sort. Local before push: lint 0, typecheck 0, **test 1 failed / 86 passed**. Patch in `pr-28-controls/control-A.patch`.

## Timeline
| Event | Time |
|---|---|
| Push | 22:31:23Z |
| Vercel suite success → "Not all checks complete yet, scheduling deferred re-check" (Actions check run already registered) | 22:31:31Z |
| **Actions CI FAILURE** on 1770fe2a (run 33813455295; only the `npm test` step failed, `control-A-ci-job.json`) | 22:34:04Z |
| `check-suite-failure` matched → "Check suite failure on implementer PR — dispatching respond-to-ci"; dispatch claimed | 22:34:05Z / 22:34:06Z |
| PR comment "🔧 Fixing CI failures — Analyzing the failed checks and working on a fix..." | 22:34:07Z |
| Same status comment on the story 1 card (list: Done) | 22:36:12Z |
| **Fix pushed by Cascade Bot**: ea29a0cf "fix(test): correct same-agent ordering expectation to match newest-first sort" (+2 −2: expectation flipped, test renamed; no production code touched) | 22:39:07Z |
| PR comment edited to "CI Failures Resolved": root cause, fix, verification (test 87/87, typecheck, lint, build), commit id | 22:39:23Z |
| Respond-to-ci run 5026b76c completed (328.9 s, $0.79) | 22:39:37Z |
| Card comment edited to "CI Fix Summary" with the same content | (edited in place, timestamp of first post 22:36:12Z) |
| Actions CI SUCCESS on ea29a0cf (job ran 7.5 min, slow runner) | 22:47:01Z |
| Review dispatched on the Actions suite | 22:47:03Z |
| **Review: APPROVED** (run e340ab5e, 165.4 s, $0.55); summary on the card | 22:49:39Z |
| Revert pushed by the evaluator: 6420141 restores the test file to a85aa03b (tree identical to the pre-control head; local test 86/86) | 22:50:09Z |

## Answers to the directive's questions
- Does respond-to-ci fire: yes, 1 s after the failure event, on the check-suite-failure trigger.
- What does it post: a status comment on the PR and on the card at start, edited in place at the end into a report with root cause, fix, verification and commit id. The card was in the Done list; it was still found and updated.
- Does it try to fix: yes. It diagnosed that the test, not the sort, contradicted the specification, changed the test's expectation, and did not touch `lib/changelog.ts`. This is the correct repair.
- Does the reviewer re-run: yes, on the fix head after CI passed, and approved.
- Repair loop: none; one response, one review. The respond-to-ci cap in the directive was not needed. (The check-suite-failure handler has its own cap of 3 attempts, `src/triggers/shared/gates.ts:175`.)

## Cost of the control cycle (single run)
Two runs, $1.33, 8.2 min tool time (respond-to-ci $0.79 / 328.9 s; review $0.55 / 165.4 s). The revert will trigger one more CI and review cycle; that cost is logged, not scored.

## Rows
- Row 5 negative control: the failing test was reported as failing (CI failure event handled, "npm test" named as the failing step in the report) and repaired correctly.
- Row 7b: the pipeline result (a failure) was observed and reported by the tool on both the PR and the card, with the fix. In Phase B nothing was reported because respond-to-ci was not enabled; with it enabled the report exists for failures. Successes are not reported as such: no comment says "CI passed" on any PR; success only shows through the review being dispatched.

## Files
`pr-28-controls/control-A.patch`, `control-A-tool-fix.patch`, `control-A-ci-job.json`, `reviews-final.json`, `review-comments-final.json`, `issue-comments-final.json`, `commits-final.json`, `story1-card-actions-after-controls.txt` (all scrubbed).
