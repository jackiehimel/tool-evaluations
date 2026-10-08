## 4. Definitions used everywhere

Human action categories. Only the second one affects a score.
- Gate action: a permitted approval or trigger the plan expects (moving a card, clicking approve, replying "go", answering a question the tool asks). Logged, never penalized.
- Corrective work: editing, fixing, finishing, re-prompting or re-running because the output was wrong or incomplete. Logged with minutes and a diff. This is what turns "Does it" into "Partly."
- Setup work: installation, credentials, configuration before the run. Logged under setup time, not per stage.

Scores.
- Does it: output accepted with no semantic change. Cosmetic edits (typos, formatting) are logged and do not change the score.
- Partly: corrective work was needed, up to rewriting one section or re-running once with a clarified prompt.
- Doesn't: the tool cannot do it, the output needed more than one section rewritten, or the tool's own source had to change.
- Blocked: an external factor prevented the test (for example a hosting rule). Evidence must show the same action fails without the tool.
- Not tested: not attempted. Reason required.

Aggregation. When a stage has several runs (for example stage 4 across several stories), the row shows every run and the row score is the lowest run.

Attempt. One end-to-end execution of a step. A re-run after a stated change counts as a new attempt. Environment failures (network, provider outage) are logged as such and do not count.

Two-failure rule. Two failed attempts on one step: score that item Doesn't (or Blocked with evidence), log why, and continue with the next step that does not depend on it.

Time. All timestamps ISO 8601 in one timezone. Every run logs: start, running, waiting-for-human, blocked, end. Tool time = running. Evaluator time = waiting-for-human.

Cost. Model tokens and dollars from the provider or tool's own accounting per run; tool fees; evaluator minutes. Reported separately, never summed into one number.

Approval protocol. The executing session pauses at the end of every numbered step and before any action that changes the repo (branches, PRs, commits), the board, credentials, or starts a run, and waits for "go." Writing files inside the eval repo folder and reading logs need no approval. Every "go" is logged with a timestamp. Silence is not consent.

Subagents. May read and summarize. May not write to the repo, the board, or credentials, and may not score. Their output is checked by the main session and logged.

## 5. Coverage matrix (Goal 1)

Scored per section 4. Human confirmation: before any row is scored, the executing session prints `JUDGMENT REQUIRED: stage N` with the evidence and its proposed score, and waits for the evaluator to confirm or change it.

| # | Stage | "Does it" when | Evidence required |
|---|---|---|---|
| 1 | BRD | From the section 9 prompt, the tool produces a requirements document containing: scope, exclusions, assumptions, acceptance criteria, open questions. Missing sections = Partly. | The document, word-diff of any edits, minutes spent. |
| 2 | Stories | It creates independent work items in the PM tool, each with acceptance criteria, that together cover the requirements (traceable). Count is not scored; record it. | Card exports. |
| 3 | Architecture | Before any code, it produces a plan naming files, components, data flow and at least one considered alternative, consistent with repo conventions. | The plan with its timestamp preceding the first commit. |
| 4 | Coding | For an approved story, it opens a PR on a branch (never main) that satisfies the story's frozen acceptance checklist (section 9) and changes no files outside the approved scope; unrequested features = Partly. | PR link, diff, changed-files audit against scope. |
| 5 | Unit tests | The PR adds or updates tests for the change and all of `lint`, `typecheck`, `test`, `build` exit 0. Negative control: a PR containing a deliberately failing test must be reported as failing. | CI logs, local reproduction log, negative-control result. |
| 6 | Review | A review is posted by a separate identity, findings are ranked by severity, and the tool fixes at least one valid finding on request. Negative control: an injected bug must be caught. Record whether the reviewer is a separate process, not just a separate account. | Review text, reviewer config, fix commit, negative-control result. |
| 7 | Deploy | Split into 7a "initiates or manages deployment" and 7b "observes and reports the pipeline result." Existing CI deploying on its own credits 7b only. | Deployment record, tool's report. |
| 8 | Smoke test | Something checks the deployed URL after deployment and reports pass or fail on the card or PR. Reacting to CI failures does not count here (it is recorded under reliability). | The check's output. |
| 9 | Orchestrator | List every hand-off (prompt→BRD→stories→plan→code→review→deploy→verify). Score only transitions the tool coordinates. Each human gate must be recorded by the human with a timestamp. Cost per run visible. | Transition table with actor and timestamp; dashboard screenshot. |
| 10 | Extensibility | Using the tool's supported extension mechanism (configuration, manifest or plugin, not a fork), define a read-only agent that posts a short repository summary to a card, run it once on demand and once on a short schedule, and confirm it had no write permissions. Spike this in preflight; if the mechanism does not exist, score Doesn't and skip step 9. | Definition file, two run records, permission check. |

Two questions answered once per tool, from observation: what this does that the repo's existing CI/CD does not; can stories and findings be exported to a customer's backlog (Jira, Trello), tested only where actually tried, otherwise "documentation only."

Hosting rule, predeclared: if previews are blocked for tool-authored commits, 7a is Blocked, provided a manual branch push through the same hosting fails the same way (evidence required). It is not an excuse for 7b, 8 or 9.

## 6. Requirements fit (Goal 2)

| Requirement | Test | Score |
|---|---|---|
| Day-to-day operation needs no command line after install | Count CLI actions during Phase C. Zero = Yes; only for exceptions = Partly; routine = No. | |
| A person approves at every stage hand-off | From the stage 9 transition table. | |
| Runs against the customer's own repo and PM tool | Yes only for the integrations actually tested; others "documentation only." | |
| Cost per run is visible in tokens or dollars | Dashboard or log shows it without extra tooling. | |
| Model provider can be changed by configuration only | Attempt to switch provider in config; do not run. | |
| Operable by a two-person team plus tokens | Not testable in this evaluation. Record observed operating tasks and their minutes; score Not tested. | |
| Time to first working setup | Measured from a documented cold start (section 10 step 0), not a warm reset. Recorded as a measurement; no pass mark. | |

## 7. Verdict rules (Goal 3)

Mandatory before any positive verdict: security checklist done, license checklist done, hosting answer known, requirements table filled.

Adopt: stages 4, 5, 9 and 10 score Does it; stages 2, 3, 6 and 7b score at least Partly; stage 1 and 8 at least Partly or Blocked with evidence; no requirement row scores No; license permits commercial use and rebranding (counsel to confirm).

Fork: stages 4, 9 and 10 score Does it; up to three other stages score Doesn't; license permits modification and redistribution.

Build: stage 4 or 9 or 10 scores Doesn't. The tool may still be wrapped as the coding agent.

Reject: license blocks resale, or a security finding cannot be mitigated by configuration.

Inconclusive: the early stop fired, or more than two rows are Not tested. No verdict is issued; state what would be needed.

Early stop: if stage 4 fails on all three quick stories, stop, mark remaining rows Not tested, verdict Inconclusive.
