# Cezar — orchestrator run prompt (headless)

Audited against TRACK-B-RULES.md and PROCEDURE.md by an independent reviewer before use. Paste into a fresh Cursor chat opened in the tool-evaluations repo.

---

Read AGENTS.md, tools/_shared/TRACK-B-RULES.md, tools/cezar/PROCEDURE.md and tools/_shared/tasks/* before doing anything. This go authorizes the Cezar evaluation only, in the three steps below. Each step ends with a report and a stop.

HARD RULES
- Scope lock per AGENTS.md. Nothing outside tools/cezar/ changes in this repo. Never commit anything in ~/ai-garage-web; the only changes there are the ones Cezar makes on its own branches and worktrees, and all are removed at cleanup.
- Evidence: one file per observation, named E-CZ-NNN-<slug>.<ext>, under tools/cezar/evidence/. Each MANIFEST row = ID | ISO-8601 timestamp | test | what it shows. Evidence files are never edited after creation. If the scrub check flags an uncommitted evidence file, delete it, recapture with redaction applied at capture, use the next ID, note the skipped ID in MANIFEST.
- Redaction at capture: record "gh detected: yes/no", never auth output. Record issues and PRs by number and branch name, never full URL. Operator machine = OS + arch only. No names of people or accounts. No secrets; verify credentials exist without printing them.
- Commit only in this repo, as evaluator <evaluator@tool-evaluations.invalid>, after SCRUB_LIST=~/cascade-eval/scrub-list.txt sh scripts/precommit-check.sh passes. Never print the scrub list.
- ~/ai-garage-web: never push to main, never merge, draft PRs only, and you never run gh pr create or git push yourself — only Cezar may, through its own features.
- Cost: poll per-task cost from Cezar's API or CLI at least every 60 s during any run; stop a task at $5.00 and record "cap stop" as its outcome. Total ceiling for this go: $25 across all tasks; stop and report if reached. If Cezar exposes no cost figure headless, stop after step 1 and raise it.
- Assistance = any action beyond starting a task and reading output (retry, config change, reworded task, any git/gh action). Record each by type. Initial outcome = result before any assistance. An attempt = one start of a test's task; a third attempt is not permitted.
- Headless limits: anything that needs the cockpit UI is Not tested with that reason. Never infer Doesn't from a UI-only step. No time estimates; measured time comes from tool timestamps only.

STEP 1 — read-back and T-0 only
1a. List the exact commands you will run for T-0 (install, start, probe the API, capture outputs), in order, with the working directory for each. Stop and wait for my go.
1b. After go: run T-0 from ~/ai-garage-web with `npx cezar-cli` in the background with a 120 s capture window. Write E-CZ-001-evaluation-unit.md: Cezar version/build and the npm package version string, install method, agent CLI and model as Cezar reports it, operator OS+arch, target repo path, `git rev-parse HEAD` and `git rev-parse origin/main` on ~/ai-garage-web main, `git worktree list`, `git branch -a`, `git status` (clean required; if not clean, stop and report). Write E-CZ-002-first-start.txt: terminal output, port, gh detected yes/no, whether per-step tokens and cost are exposed by the API/CLI and where. Cockpit screenshot: Not captured (headless) — say so in MANIFEST. Commit. Report and stop.

STEP 2 — T-1, T-3, T-4, T-2 (after my go)
Order is T-1, T-3, T-4, T-2 because T-2 is the most UI-bound.
T-1: record the exact file or flag used to set maxParallel=3. Start the three quick stories (tasks/story-1,2,3, text verbatim) so they overlap — background CLI runs or the API. Capture a timestamped status poll showing ≥2 tasks running at once; if they serialize, record that. Evidence: `git worktree list`; per-task status; per-step tokens and cost; each worktree's diff. The cockpit-legibility half of the pass criterion is Not tested (headless), so T-1 is at most Partly.
T-3: set CEZ_FOLLOWUPS=1; confirm the Autonomous flag is off and capture the exact flag/config line. Start one task with exactly "Add a changelog page to the site." Evidence: run output, Inbox contents via API, worktree diff if it built. If there is no headless way to turn Autonomous off or read the Inbox, T-3 is Not tested with that reason.
T-4 (a): find the exact label Cezar polls for in its docs/config and record it. Run `gh issue list --label <label>`; if any existing issue carries it, T-4(a) is Not tested, skip. Otherwise create one issue with the frozen Changelog text verbatim, set CEZ_AUTOMATIONS=1, observe for one polling interval, then unset CEZ_AUTOMATIONS, stop Cezar, close the issue. Any task it starts counts toward the cap. (b): create a task through the HTTP API with curl using story 1's text verbatim; save the command with no tokens and the response.
T-2: set CEZ_REVIEW_GATE=1, run story 2 headless. Record only what Cezar's CLI/API itself does: whether the run holds in a review state and whether the API exposes the diff. Do not create a PR, send session notes, or push anything. Sub-steps that need the cockpit are Not tested. T-2 is at most Partly.
Per test: initial outcome, assistance, final outcome, on the TRACK-B-RULES scale.
Cleanup: remove every worktree and branch Cezar created; close any issue or PR it opened; remove any Cezar config or env file it wrote inside ~/ai-garage-web. Write E-CZ-0NN-integrity.md showing `git rev-parse origin/main` unchanged from E-CZ-001, `git worktree list` with only the main tree, `git branch -a` with no Cezar branches, `git status` clean. Commit. Report and stop.

STEP 3 — audit and gate (after my go)
Spawn a fresh subagent with no conversation history. Give it exactly two inputs: the proposed-outcomes table and read-only access to tools/cezar/evidence/. It marks each test supported / unsupported / evidence-missing with the evidence IDs it relied on. Save its verbatim output as E-CZ-0NN-audit.md with a MANIFEST row. Do not revise outcomes after the audit. Present outcomes and audit together at one JUDGMENT REQUIRED gate and wait.
After my confirmation: write tools/cezar/RESULTS.md from tools/_shared/RESULTS-TEMPLATE.md — per-test outcomes, cost and measured time from evidence timestamps, which ADLC lifecycle step Cezar improves, constraints, fit beside a backbone, what the evidence does not support. Every capability claim carries a provenance label (stock-native / supported-configuration / evaluator-built / absent). No overall score, rating or recommendation. Commit. Report OUTCOME / WHAT I DID / EVIDENCE / WHAT CHANGED / OPEN / GATE and stop.
