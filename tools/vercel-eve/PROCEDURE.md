# Vercel Eve — Foreman software-factory template — procedure

Track B. Rules in `tools/_shared/TRACK-B-RULES.md`. Registered before any run.

**What it is.** Eve is Vercel's open-source agent framework (beta). Foreman is its software-factory template: a GitHub issue labelled `factory` is routed through classifier → analyst → implementer → reviewer agents and ends as a draft PR with per-criterion pass/fail. Runs on Vercel Functions, Workflows, Sandbox and AI Gateway. Sources: vercel.com/docs/eve, vercel.com/docs/eve/software-factory, vercel.com/kb/guide/eve-software-factory (sources as of Oct 2026).

**Question.** Does the stock Foreman pipeline take the frozen Changelog task from issue to a reviewed draft PR without a person steering the agents, and what does each stage show?

**Setup.** Vercel account (the template uses Sandbox and Workflows; check whether the current plan allows them before deploying — record the answer). GitHub App via Vercel Connect with write access to contents, issues and PRs on the target repo.
1. Deploy from vercel.fyi/eve-software-factory ("Deploy now").
2. `FACTORY_REPO` = the AI Garage web repo (`owner/repo`). `FACTORY_LABEL` = `factory`. `FACTORY_BRANCH_PREFIX` = `factory/`. Leave Linear out: remove `agent/channels/linear.ts`, `agent/connections/linear.ts`, `LINEAR_CONNECTOR`.
3. Record the deployment URL and the GitHub App name it installed.

## Tests

### T-0 Deploy and baseline
Record: Vercel plan, whether Sandbox/Workflows were available, deploy outcome, GitHub App installed, which models the template defaults to. Evidence: deployment screenshot; env var names (not values); Agent Runs page empty state.

### T-1 Issue to draft PR (stages 1–6 chain)
Open an issue in the target repo with the frozen Changelog feature text (`tools/_shared/tasks/changelog-feature.md`). Add the `factory` label. Do nothing else.
Pass = a draft PR opens on a `factory/` branch, linked to the issue, with the reviewer's per-criterion pass/fail in the PR body; progress comments appear on the issue.
Record each stage as the issue comments show it: classifier, analyst (acceptance criteria written), implementer (branch pushed, checks run), reviewer (verdict). Record whether checks actually passed.
Evidence: issue URL and comment thread; PR URL and body; `gh pr checks` output; Agent Runs screenshot for the session.

### T-2 Clarification (stage 1 — intake)
Open a second issue: `Add a changelog page to the site.` Label it `factory`.
Pass = the classifier stops and asks a clarifying question on the issue instead of building. If it builds, record what it built.
Evidence: issue comment thread.

### T-3 Red-CI fix loop (stage 5 — checks)
On the `factory/` branch from T-1, push one commit that adds a deliberately failing unit test. (Operator commit, labelled as a control.)
Pass = Foreman detects red CI and attempts a fix (cap is 2 attempts per its docs); record whether the fix removed or corrected the test and what the PR comment said. Revert the control commit afterward.
Evidence: control commit SHA; CI run; Foreman's comments; the fix commit diff.

### T-4 Observability and cost (operational)
Open Agent Runs for the T-1 session. Record: sessions, turns, tool calls, token usage per stage. Record whether USD cost is shown anywhere (docs say tokens, not dollars). Record the AI Gateway usage figure for the day.
Evidence: Agent Runs screenshots; AI Gateway usage screenshot.

## Not tested here
Linear intake. Browser-based UI bug reproduction. Multi-tenant operation. `Not tested`.

## After the run
Close test issues, close the draft PR, delete `factory/` branches. Pause or delete the Vercel deployment if it has a standing cost. Fill `RESULTS.md`. Run the audit before confirming outcomes.
