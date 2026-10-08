# OpenHands — procedure (Phase E0 output, amended 2026-09-13)

Written from the OpenHands repos and docs only (E-OH-000), then refreshed against current npm metadata, docs and pinned source (E-OH-001). Nothing installed. Derived from `~/cascade-eval/OPENHANDS-PLAN.md` with its Phase E3 dropped (D-32). The same rubric, frozen Changelog feature, model and rules as the Cascade run apply. This is a capability demonstration with one consolidated foundation run, not a reliability study.

## What the product is
Open-source OpenHands is "Agent Canvas" 1.18.0 (`@openhands/agent-canvas` on npm, `ghcr.io/openhands/agent-canvas` on Docker), MIT, plus a Python SDK and tools (`software-agent-sdk`), a public catalog of skills, automations and integrations (`extensions`), and a separate automation server (`automation`). Agent Canvas 1.16.0 remains published and installable; the separate legacy OpenHands CLI also remains at 1.16.0 and is not the package under test. Agent Canvas is a coding-agent runtime with an automation scheduler, not a lifecycle orchestrator: the current stock catalog still has no planner, story splitter, backlog manager, deploy stage, smoke-test agent or lifecycle hand-off orchestrator (E-OH-001).

## Stage map
| # | Stage | OpenHands OSS equivalent | Source | What building it would take |
|---|---|---|---|---|
| 1 | BRD | No agent. A `prd` skill exists (writes a PRD when asked). | E-OH-000 §8 | An automation or SDK agent with the prd skill and a place to store the document; prompt work. |
| 2 | Stories | No splitter. Issue-to-PR templates consume existing issues; nothing creates them. | §8 | An SDK agent that writes issues via the GitHub MCP server or `gh`. |
| 3 | Architecture | No planner agent. SDK ships `task_tracker` and `planning_file_editor` tools an agent can use inside one task. | §8 | Prompt and definition work on an SDK agent. |
| 4 | Coding | Yes: the stock `github-issue-to-pr` automation polls for a configured issue label, starts one OpenHands conversation in a clone, then the automation commits the resulting changes, pushes a branch and opens the PR under its GitHub PAT. Commit identity is not an enforced Agent Canvas setting. | E-OH-001 | Wrapping exists. Scope guard and identity enforcement remain build work. |
| 5 | Unit tests | The coding agent runs the check suite if told to; nothing enforces it. CI failures: the repo-monitor template can be asked to watch failed workflow runs, on cron. | §5 | A "respond to CI" automation on cron or on the event path. |
| 6 | Review | `github-pr-reviewer` automation: polls a label every 15 min, posts a real PR review but always with `event: COMMENT`; the verdict is text. Nothing reacts to a submitted review. | §5 | Approve / request-changes events and a review-to-fix chain are build work; the reviewer identity is whichever PAT the automation holds. |
| 7 | Deploy | None. Vercel and Netlify MCP catalog entries exist for an agent to call. | §8 | Full build. |
| 8 | Smoke test | None as such; `qa-changes` plugin does functional testing of PR changes. | §8 | A URL-check automation; the qa-changes plugin is the nearest starting point. |
| 9 | Orchestrator | The automation server supports cron locally; inbound events exist, but the current feature matrix still marks event-driven automations "—" for the local backend and "✓ VM must be reachable" for the VM backend. Cloud and Enterprise support them. No stock component supplies the lifecycle hand-off chain or its human gates. Cost per automation run appears in the Activity Log. | E-OH-000 §1, §4; E-OH-001 | The hand-off chain itself (requirements→stories→plan→code→review→fix→deploy→verify with gates) is build work on the SDK and automation API. |
| 10 | Extensibility | Strong and all OSS: skills, MCP servers, automations (with a scheduler), SDK custom agents, file-based agents, plugins, ACP harnesses (Claude Code, Codex, Gemini CLI). | §7 | The row 10 test can score Does it here; the scheduler exists. |

PM tool: Trello only as an MCP catalog entry (no template or skill); Jira and Linear have cron templates and skills; webhook-driven ticket integrations are Cloud/Enterprise only (§10). The Cascade board will be mirrored by hand for the record.

## Answers to the plan's E0 questions
1. Events: the current feature matrix still documents event-driven automation as unavailable on the local backend while scheduled and polling automations remain available. Decision: **intake is one labelled issue through the stock cron-polling automation** (15 min default, shortened for the approved run); row 4 is exercised, while row 9 is scored from documented stock absence rather than an evaluator-built chain.
2. Push and PR: yes, via the terminal tool and the PAT; identity by prompt, not config (compare Cascade finding 5, where it is hard-coded the other way).
3. Headless: Agent Canvas starts with `agent-canvas --backend-only`; E1 submits a no-op through the Agent Server `POST /api/conversations` interface. The separate legacy CLI's `openhands --headless` command is not used as Agent Canvas evidence.
4. Cost: per automation run in the Activity Log and export (`cost`); tokens per conversation in the metrics modal and SDK metrics.
5. Reviewer: real review object, always COMMENT event, verdict in text; nothing reacts to reviews or failing checks on its own.
6. License: MIT on all five repos; manifests listed in E-OH-000 §6; scan to run in E1 with `license-checker` (npm) and `pip-licenses` (Python).

## Pre-registered scoring and scope

- Documented absence from the stock product = **Doesn't**.
- Present but unexercised criterion = **Not tested**.
- Stage 9's documented absence makes the verdict **Build** before runtime testing under PLAN.md section 7. Runtime testing measures foundation quality, costs and tokens, findings and hosting behaviour; it cannot upgrade that verdict.
- One consolidated feature run cannot support reliability or latency-distribution claims. Cascade received six coding runs; OpenHands receives one consolidated foundation run. The comparison must not compare latency distributions.

## Procedure, revised (E3 dropped)
- E1 cold setup, timed from the documented clean baseline: update the host prerequisite to Node ≥24, keep `uv`, and run pinned `npx @openhands/agent-canvas@1.18.0 --backend-only`. Use model claude-sonnet-5 and a fine-grained PAT scoped to the target repo. Write BASELINE.md with package version, source/release reference, model, enabled automations and configuration hash. Verify backend health, model resolution and one successful no-op conversation submitted through `POST /api/conversations`. Installation, credential placement and the no-op each require their own prior "go".
- E2 consolidated coding-foundation run: create one labeled GitHub issue containing the complete frozen Changelog feature prompt from FEATURE.md. Use the stock `github-issue-to-pr` cron automation, shortened to one minute for the approved run, to create one fresh branch and PR. Capture label→PR wall time, summed tool runtime where available, cost and tokens, complete diff, changed-files audit against the frozen scope, tests, local reproduction, CI and hosting behaviour. Rows 4, 5a, 5b, 7a and 7b receive runtime evidence; every score still requires `JUDGMENT REQUIRED`.
- E2b reviewer and controls on that single PR: run the stock `github-pr-reviewer` once and record its formal review object, including that GitHub event remains COMMENT and the verdict is body text. Then inject the failing-test control and the off-by-one sorting control sequentially, exercising the applicable stock automation once per control. Preserve the injected, repaired and reverted diffs. Disable or pause the triggering automation immediately after the intended response so no uncontrolled chain can form. Rows 5 and 6 negative controls and row 7b receive evidence; every score still requires `JUDGMENT REQUIRED`.
- E4 extensibility: the same read-only repo-summary agent as Cascade D-18, built as an automation with a schedule; run once on demand and once on the schedule; confirm no write tools and no push. Row 10.
- Rows 1, 2, 3, 8 and 9: proposed from current source and docs under the pre-registered rule, with a citation and one-sentence SDK build note per row; not exercised by evaluator-built replacements. Row 7a uses both the documented absence of a deploy stage and observed hosting behaviour. No score is entered before evaluator confirmation.
- E5 write-up: MATRIX, REQUIREMENTS, SECURITY, LICENSE, FINDINGS, memos, EOD; then `comparison/RECOMMENDATION.md` (fork Cascade versus build on the OpenHands SDK).

## Recommendation
**One consolidated frozen-feature foundation run plus the reviewer, controls and extensibility tests; no evaluator-built lifecycle run.** Reasons: (1) no stock component covers stages 1, 2, 3, 7, 8 or the hand-off chain of stage 9, so a lifecycle run would measure evaluator-built prompting and wiring rather than the product; (2) the current feature matrix still marks event-driven automations unavailable on the local backend and available only on a reachable VM backend, Cloud or Enterprise; (3) stage 9's absence already fixes the verdict at Build, so the decision-relevant runtime questions are coding quality, identity handling, review form, control detection, scheduler/extensibility quality, cost and residual work.

Stopped here. Waiting for the evaluator to approve this amended procedure before any installation, credential placement or run.
