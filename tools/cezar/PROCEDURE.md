# Cezar (Open Mercato) — procedure

Track B. Rules in `tools/_shared/TRACK-B-RULES.md`. Registered before any run.

**What it is.** Local cockpit that queues tasks and runs Claude Code / Codex / OpenCode in parallel git worktrees, with per-step tokens and cost, a review gate, GitHub issue intake, and an HTTP API. MIT. Source: github.com/open-mercato/cezar (source: project README, Oct 2026).

**Question.** Does a person steering several coding agents at once get a clearer, safer, cheaper picture of what each one is doing than with the plain Claude Code terminal?

**Install (Mac).** Node 20+. Claude Code logged in. `gh` logged in (needed for PR features).
```
cd ~/ai-garage-web
npx cezar-cli
```
Cockpit opens at http://localhost:4321 (or the next free port). Record the version it prints.

## Tests

### T-0 Install and baseline
Record: version, port, which agent CLI it picked up, whether `gh` was detected, where tokens and cost appear. Evidence: screenshot of the empty cockpit; terminal output of the first start.

### T-1 Parallel sessions (stage 4 — coding)
Set `maxParallel` to 3 (settings or env). Start the three quick stories from `tools/_shared/tasks/` as three tasks, one after another, each with the default workflow.
Pass = all three run in separate worktrees (`git worktree list` shows three), and in the cockpit it is clear for each one: what it is doing, its state, and its diff, without reading the terminal.
Evidence: cockpit screenshot with all three; `git worktree list` output; per-step token/cost panel for one task.

### T-2 Review gate (stage 6 — review)
Restart with `CEZ_REVIEW_GATE=1`. Run story 2 (small feature). When it reaches the review state: read the diff in the cockpit, send one note back into the same session asking for one concrete change, confirm the agent applies it, then push a draft PR from the cockpit.
Pass = run holds at review; diff readable; note reaches the same session; draft PR opens on a non-main branch.
Note: this is a human review gate, not an AI reviewer. Record it as such.
Evidence: screenshot at review state; the note and the agent's response; PR URL; `gh pr view` output.

### T-3 Clarification (stage 1/2 — intake)
Autonomous flag OFF. Start a task with the deliberately thin prompt: `Add a changelog page to the site.` and nothing else.
Pass = the agent stops and asks what the page should contain, or Cezar surfaces a follow-up in the Inbox (`CEZ_FOLLOWUPS=1`). Record what it asked. If it just builds something, that is the outcome: record what it built.
Evidence: screenshot of the question or Inbox item; or the diff if it built without asking.

### T-4 Intake and API (stage 9/10 — orchestration, extensibility)
(a) `CEZ_AUTOMATIONS=1`. Create a GitHub issue in the target repo with the frozen Changelog feature text and the label Cezar polls for. Does a task start on its own?
(b) From a second terminal, create a task through the HTTP API (`/api/v1/...`, path per README) with `curl`. Does it appear and run?
Pass = (a) task starts from the issue; (b) task created by API.
Evidence: issue URL; cockpit showing the task with its source; the curl command (no tokens) and response.

## Not tested here
AI code review (Cezar has none stock). Multi-user operation. Server/VPS mode. These are `Not tested`, not `Doesn't`.

## After the run
Delete the worktrees and branches Cezar created. Close the test issue and draft PR. Fill `RESULTS.md` from the template. Run the audit before confirming outcomes.
