# E-018 — Negative control B: planted off-by-one on the sorted feed (row 6 negative control)

Branch `feature/changelog-data-feed` (PR #28). Pushed under the evaluator's "go" of 2026-09-03T18:06 EDT (D-27), before the Sep 3 directive (D-28) narrowed the controls to the failing test. Times UTC.

## The control
Commit 24d002dd "refactor(changelog): tidy feed export", authored by the evaluator role identity, one line: `listChangelogEntries()` returns `buildChangelogFeed(backlogAgents).slice(1)`, dropping the newest entry of the live feed. The existing six tests exercise only the builder, so the suite stays green: local lint 0, typecheck 0, test 85/85 before the push. Patch in `pr-28-controls/control-B.patch`.

## Timeline
| Event | Time |
|---|---|
| Push | 22:09:46Z |
| Vercel suite success → review dispatch claimed (finding 20; Actions check run not yet registered) | 22:09:52Z |
| Actions CI SUCCESS on 24d002dd (event deduped) | 22:12:24Z |
| **Review: CHANGES_REQUESTED** (run bc4addb9, 168.2 s, $0.42) | 22:12:33Z |
| `pr-review-submitted` → respond-to-review run 0baae3a9 started | 22:12:36Z |
| Fix commit a85aa03b by Cascade Bot pushed | 22:20:04Z |
| Vercel suite success → "Not all checks complete yet, scheduling deferred re-check" (Actions check run already existed) | 22:20:14Z |
| Respond-to-review completed (479.6 s, $1.20) | 22:20:36Z |
| Actions CI SUCCESS on a85aa03b (run queued about 5 min) | 22:25:20Z |
| Review dispatched on the Actions suite (correct path) | 22:25:23Z |
| **Review: APPROVED** (run e2276462, 161.0 s, $0.35) | 22:27:58Z |
| `pr-ready-to-merge` returned null (no `auto` label); PR open, unmerged | 22:28:00Z |

## What the reviewer said
One Blocking finding at `lib/changelog.ts:31`: names the dropped newest entry, cites the PR body and the card's acceptance criteria as the specification, states the fix (`return buildChangelogFeed(backlogAgents);`), notes that no test calls `listChangelogEntries()` so `npm run test` cannot catch it, and recommends a test against the real registry. Inline comment on the line. The commit message did not hint at the bug. Full text in `pr-28-controls/reviews-final.json`.

## What the tool did with it
Respond-to-review removed the control itself: a85aa03b restores the original line and adds a `listChangelogEntries` test (+14 lines) asserting the full-registry count and equality with the builder, as the reviewer recommended. Patch in `pr-28-controls/control-B-tool-fix.patch`. The evaluator did not revert anything; "removed afterward" was done by the tool. The final PR #28 head a85aa03b differs from the pre-control head 9636257 only by the added test.

## Cost of the control cycle (single run)
Three runs, $1.97, 13.5 min tool time: review $0.42, respond-to-review $1.20, review $0.35.

## Observations for other rows
- Finding 20 both ways in one cycle: the first Vercel event dispatched review before Actions existed; the second deferred correctly because the Actions check run already existed.
- Respond-to-review took 8 minutes for a one-line fix plus a test (the worker's own verification loop).
- The commit was authored by a non-bot identity and the review still dispatched: the author gate is on the PR author, not the commit author.

## Files
`pr-28-controls/control-B.patch`, `control-B-tool-fix.patch`, `reviews-after-B.json`, `review-comments-after-B.json`, `reviews-final.json`, `review-comments-final.json`, `issue-comments-final.json`, `commits-final.json` (all scrubbed).
