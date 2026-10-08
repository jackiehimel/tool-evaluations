# E-017 — Phase C step 9, feature story 3 (nav link + docs), implementation, review and respond-to-review loop

All times UTC. Runs from `runs list --json`; PR state from the GitHub API, exported (scrubbed) in `pr-30/`.

## Timeline
| Event | Time |
|---|---|
| Evaluator: story 2 card In Review → Done (gate action) | 21:27:59Z |
| `runs trigger --agent-type backlog-manager` (fourth on-demand run, 0ccb0d72, 20.1 s, $0.25) | 21:29:21Z |
| "Selected for Development" on the nav+docs story: "both already in DONE, so no blocking work remains" | 21:29:33Z |
| Card Backlog → To Do by the tool; implementation trigger matched | 21:29:37Z |
| Implementation run 3503ae79 started; card → Doing | 21:29:49Z |
| **PR #30 opened, base `main`** (not stacked), head 344fcd82, +7 −5 in `lib/garage-content.ts` and `docs/architecture.md` | 21:31:25Z |
| Vercel check suite success → review dispatch claimed (run 46956f4d) while Actions had no check run yet (finding 20) | 21:31:28Z / 21:31:30Z |
| Run 3503ae79 completed (126.4 s, $0.88); card → In Review; AC checklist 6/6 ticked by the tool, dependencies 0/2 | 21:31:56Z / 21:31:58Z |
| Local reproduction on 344fcd8: npm ci, lint 0, typecheck 0, test 79/79, build 0 | 21:31:58Z → 21:32:14Z |
| Actions CI SUCCESS on 344fcd82; the event was dropped by the review dedup | 21:32:39Z / 21:32:41Z |
| **Review 1: CHANGES_REQUESTED** (46956f4d, 115.8 s, $0.58): two [BLOCKING], two inline comments | 21:33:09Z |
| Respond-to-review 1 (8a35a819, 93.6 s, $0.59): commit 01e242c9 **reverts both hunks**; replies to both inline comments | 21:33:14Z → 21:34:47Z |
| Vercel suite success → review 2 dispatched on 01e242c9 before Actions (finding 20, 2/2) | 21:34:25Z / 21:34:27Z |
| Actions CI SUCCESS on 01e242c9 | 21:35:39Z |
| **Review 2: CHANGES_REQUESTED** (913d568c, 73.7 s, $0.39): PR is a no-op titled as a feature; card AC ticked but false; recommends draft/close or retitle | 21:35:32Z |
| Respond-to-review 2 (b7d6ade0, 200.2 s, $1.22): unticks four AC items on the card (AC 2/6); commit 31dc4f48 adds a six-line source comment; states it has no PR-edit action | 21:35:36Z → 21:38:56Z |
| Vercel suite success → review 3 dispatched on 31dc4f48 before Actions (3/3) | 21:38:32Z / 21:38:34Z |
| **Review 3: CHANGES_REQUESTED** (9f91b543, 110.8 s, $0.48): [SHOULD_FIX] title/body stale | 21:40:15Z |
| Respond-to-review 3 (1e232ef2, 290.3 s, $1.55): commit 757ca4f7 adds four more comment lines saying the PR title "should be disregarded"; re-tests `create-pr --no-commit --no-push`, confirms no edit command | 21:40:20Z → 21:45:10Z |
| Vercel suite success → review 4 dispatched on 757ca4f7 before Actions (4/4) | 21:44:41Z |
| **Review 4: APPROVED** (72aa6ed0, 102.6 s, $0.40): "comment-only no-op", title mismatch kept as [SHOULD_FIX] | 21:46:16Z |
| `pr-ready-to-merge` handler returned null (no `auto` label); no merge; card stays In Review | 21:46:19Z |

Nothing was in flight after 21:46:26Z. The evaluator was asked at 17:39 EDT whether to stop the loop and had not answered when it ended by itself; no intervention was made.

## Cost and time (single runs, tool accounting)
| Run | Agent | Duration | Cost |
|---|---|---|---|
| 0ccb0d72 | backlog-manager | 20.1 s | $0.25 |
| 3503ae79 | implementation | 126.4 s | $0.88 |
| 46956f4d | review 1 | 115.8 s | $0.58 |
| 8a35a819 | respond-to-review 1 | 93.6 s | $0.59 |
| 913d568c | review 2 | 73.7 s | $0.39 |
| b7d6ade0 | respond-to-review 2 | 200.2 s | $1.22 |
| 9f91b543 | review 3 | 110.8 s | $0.48 |
| 1e232ef2 | respond-to-review 3 | 290.3 s | $1.55 |
| 72aa6ed0 | review 4 | 102.6 s | $0.40 |
| Total | 9 runs | 18.9 min | $6.33 |

Card → PR: 108 s from the tool's To Do move (21:29:37.245Z → 21:31:25Z; 96 s from the Doing move). _Correction 2026-09-03T18:22:23-04:00: measured from the To Do move like every other run; 96 s was first written here from the Doing move._ Card → final approval: 16.6 min.

## Row 4 audit (changed files against the frozen scope)
- First head 344fcd82: `lib/garage-content.ts` (+1, inside `lib/`) and `docs/architecture.md` (+6 −5, **outside** the frozen scope: `app/changelog/`, `lib/`, `components/portal-nav.tsx`, tests). The docs edit is exactly what the card planned (finding 3, D-22); the coder followed its card.
- Base branch: `main`, although both dependencies exist only on unmerged branches. Story 2's coder had detected the same situation and stacked; story 3's coder noted it in the PR body ("filed a friction report on the card", which does not exist on the card) and opened against main anyway. Inconsistent handling on two runs of the same situation.
- The story's acceptance checklist was satisfied by the first head (6/6). The delivered PR (final head 757ca4f7) satisfies none of the four functional items: the diff against main is ten comment lines in `lib/garage-content.ts` and nothing else. No `components/portal-nav.tsx` change (correct).
- Unrequested changes on the final head: the ten-line comment block (nobody asked for it; the reviewer asked for a retitle or a draft).
- Corrective work by a human: 0 during the run. To make this story deliverable a human would have to restore the first commit on a stacked base and retitle, or close the PR and re-run once the dependencies merge.

## Row 5
- 5a: the story required no tests and none were added (branch is off main; test count 79, the same as main).
- 5b: local reproduction green on 344fcd8 (lint, typecheck, test 79/79, build). Actions CI SUCCESS on every head (344fcd82 21:32:39Z, 01e242c9 21:35:39Z, 31dc4f48 and 757ca4f7 likewise, deduped events at 21:39:35Z and 21:45:43Z). The PR's self-reported test plan lists eslint on one file only (finding 13 pattern).

## Row 6
- Separate identity: reviews by the reviewer account; replies by the implementer identity. Separate process: each review is its own worker container and run record (`agentType: review`).
- Ranking: findings labelled [BLOCKING] and [SHOULD_FIX], grouped under Architecture & Design / Code Issues / Questions; inline comments on the exact lines.
- Validity: review 1's two blocking findings were correct and evidence-based (the reviewer built the branch and read the route manifest, and compared the card's dependency checklist against backlog-manager's claim). Reviews 2 and 3 were also correct about the no-op and the stale title.
- Fix on request: exercised, three times, automatically (no human request; the tool chains `pr-review-submitted` → respond-to-review). The first response reverted the feature rather than choosing the reviewer's hold/draft option; the second and third wrote source comments to work around a missing PR-edit action. Finding 21.
- The reviewer's own re-run of the checks masked finding 20 on every round.

## Row 9 observations
- Transition stories → coding: tool (backlog-manager), on the on-demand CLI trigger, no human gate (D-21/D-24).
- Transition code → review: tool, on the Vercel check suite, not on the project's CI (finding 20).
- Transition review → fix: tool, automatic, no human gate, no round cap (finding 21).
- The card's checklist was edited by two different agents in opposite directions (implementation ticked 6/6, respond-to-review unticked four).

## Files
`pr-30/pr-30.json`, `pr-30/pr-30.diff` (first head); `pr-30/pr-30-after-response.diff` (empty, second head); `pr-30/pr-30-final.json`, `pr-30/pr-30-final.diff` (fourth head); `pr-30/reviews.json`, `pr-30/review-comments.json`, `pr-30/issue-comments.json` (scrubbed: handles → role tokens, numeric user id → 0).
