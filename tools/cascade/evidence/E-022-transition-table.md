# E-022 — Row 9 transition table (all hand-offs, actor and timestamp)

Built from SETUP-LOG.md and E-010 to E-019. Times UTC. "Gate" = a human action the plan permits; "CLI" = a command the evaluator had to run; "tool" = Cascade acting on a trigger with no human in the loop.

| # | Hand-off | Actor | Timestamp(s) | Coordinated by the tool? | Human gate? | Notes |
|---|---|---|---|---|---|---|
| 1 | prompt → plan (BRD/architecture) | Gate: evaluator drags the feature card to Planning; tool: planning run ca78834e | drag 01:45:11Z (Sep 3); run 01:45:11Z → 01:47:59Z | yes (pm:status-changed) | yes | The drag passed through To Do, Doing and In Review on the way (finding 1); the implementation trigger matched and was stopped only by the capacity gate. |
| 2 | plan → stories | Gate: evaluator drags the card to Splitting (= approves the plan); tool: splitting run 43ec5dc6 | drag 02:00:32Z; cards 02:01:15Z, 02:01:32Z, 02:01:47Z | yes | yes | Plan approved as written incl. an out-of-scope docs step (D-22). |
| 3 | stories → code | CLI: evaluator runs `runs trigger --agent-type backlog-manager` (D-24); tool: selects a story, moves it to To Do, implementation dispatches at once | story 1: CLI 02:33:18Z, To Do 02:33:35Z; story 2: CLI 03:18:0xZ, To Do 03:18:20Z (after a blocked run at 03:04:42Z and the Done mapping, D-26); story 3: CLI 21:29:21Z, To Do 21:29:37Z | yes, once triggered | **no** approval of the story itself; the CLI trigger is a workaround (findings 16, 17), and the evaluator had to move each finished card to Done first (03:03:03Z, 21:27:59Z) to free capacity (finding 9) | Under D-21 the stories→code hand-off has no human gate by design. |
| 4 | code → review | Tool on `check-suite-success` | story 1: 403 twice (02:34:57Z, 02:36:02Z, finding 18) → evaluator granted Actions read and ran `gh run rerun` at 02:50:56Z → review 02:52:02Z; story 2: 03:21:20Z on the Actions suite; story 3: 21:31:30Z on the Vercel suite before CI (finding 20) | yes | no | One corrective CLI action on story 1. Dispatch fired before CI on 5 of 8 heads (PR #30 ×4, PR #28 control B first head). |
| 5 | review → fix | Tool on `pr-review-submitted` from the reviewer persona → respond-to-review | PR #30: 21:33:12Z, 21:35:34Z, 21:40:18Z (three rounds, finding 21); PR #28 control B: 22:12:36Z | yes | **no**, and no round cap | Four review rounds on PR #30 ended only when the reviewer approved. |
| 5b | CI failure → fix | Tool on `check-suite-failure` → respond-to-ci | PR #28 control A: 22:34:06Z; fix pushed 22:39:07Z | yes | no (cap: 3 attempts) | E-019. |
| 6 | review → merge | Tool's `pr-ready-to-merge` handler | returned null on every approval (e.g. 21:46:19Z, 22:28:00Z) | yes, gated by the `auto` label, not by a person | label, not a human | Not exercised (never-merge rule). The same label also enables unattended backlog feeding (finding 16). |
| 7 | merge → deploy | none | — | no | — | No deploy stage in the tool; hosting blocked previews for bot-authored commits (7a Blocked, D-31). |
| 8 | deploy → verify | none | — | no | — | No smoke-test agent type (row 8). |

Cost per run: visible per run in `runs list --json` (`costUsd`, `llmIterations`) and in `runs show` (token counts, e.g. E-016), exported in E-020. The dashboard shows the same figures per run (seen during Phase B and C; screenshot skipped per D-32).

Human actions during Phase C (for the requirements table): gate actions 2 drags + 4 Done moves + 1 board re-file; CLI actions 4 backlog-manager triggers + 1 CI re-run + 1 token permission change (GitHub UI) + 1 PM mapping change (`integration-set`); corrective edits to tool output: 0.
