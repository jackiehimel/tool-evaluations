# ADLC evaluation plan (v2)

Written Sep 2, 2026, revised after independent review. Roles: the evaluator (runs the tests), the engineering lead (partner; ranges the integration and packaging hours), the sponsor (asked for the ADLC, decides build versus adopt). No personal names appear anywhere in the eval repo.

Honest scope note: this is a single-evaluator capability evaluation, not a reliability study. Every run is executed once unless stated. Results are labeled "capability demonstration, single run." Reliability claims are out of scope.

## 1. Background

The sponsor asked for a turnkey AI development lifecycle (ADLC) that can be sold to small customers as a two-person team plus token costs. The evaluator proposed a nine-agent pipeline. The sponsor also asked for a library of read-only maintenance agents and treats the two as one ecosystem.

Before building from scratch, the evaluator and the engineering lead agreed to test existing open-source ADLCs on one real repo with identical tasks and see how much of the pipeline they already cover. A first attempt (Sep 1) tested only the coding stage with a patched tool; its records are kept as a historical appendix and contribute no scores.

## 2. Goals and what success looks like

Goal 1. Evaluate each tool on its own merits.
Success: the coverage matrix (section 5) is filled for the tool, every score confirmed by a human, with an evidence manifest entry for every row.

Goal 2. Measure fit against the sponsor's requirements.
Success: the requirements table (section 6) is filled with Yes / Partly / No / Not tested per tool, each row tied to a named step.

Goal 3. Decide whether the tool can be the foundation of our own offering.
Success: an Adopt / Fork / Build / Reject / Inconclusive verdict (section 7) with reasons, plus the list of what we would have to add or change to ship it under our brand, run the maintenance agents on it, and use it as a customer-facing agent dashboard. Includes the license checklist and how a customer would host it.

Goal 4. Produce a live demo.
Success: a ten-minute demo path rehearsed once end to end from a clean state and recorded. (Merging anything into the internal project is a separate decision made by the engineering lead, never a score input.)

The exercise has failed if: any matrix score lacks an evidence entry, or the demo has not been rehearsed.

## 3. The question, in one sentence

For each tool: which of the nine lifecycle stages does it do out of the box, how well, at what cost and with how much corrective human work, and can we add our own agents to it.

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

## 8. (Removed)

The hours model was removed on 2026-10-07. Section numbers are unchanged so existing references still resolve. Goal 3's list of what a tool would need added replaces it; no hour estimates are made.

## 9. The test feature and quick stories

Frozen before either tool runs. Acceptance checklists live in `FEATURE.md` and are not shown to the tools.

Feature prompt (stage 1 input, two paragraphs):

> Add a "Changelog" page to the site at `/changelog` that lists recent updates across all agents in the registry. Each agent's `updates[]` entries (date, author, note) should appear as one combined feed, newest first, showing the date, the agent's display name, the author and the note. Add a "Changelog" link to the portal nav. Follow the existing page and component patterns, use design tokens only, and keep the registry as the single source of truth.
>
> Include unit tests for the data function. Handle these cases: an agent with no updates, two updates on the same date (order by agent name), and an update with a missing author (show "unknown"). Dates are ISO strings; display them as YYYY-MM-DD. The page must build and pass the full check suite.

Acceptance checklist (frozen, hidden from tools): route exists; nav link present; feed sorted newest first with the tie rule; the three edge cases handled; tests exist for the data function and cover the three cases; no raw colors; no files changed outside `app/changelog/`, `lib/`, `components/portal-nav.tsx`, tests, and any `lib/*.test.ts`; full suite passes.

Expected decomposition: 3 stories, tolerance ±1. Deviation is recorded, not penalized.

Quick stories (stage 4 benchmark, one run each, from `stories/`): page title, site footer, per-route titles. Their acceptance checklists are in the story files. They count toward stage 4 only; the feature stories count toward all stages. Row 4 shows all runs and takes the lowest.

Negative controls (stage 5 and 6): after the feature PRs exist, the evaluator pushes one commit to a feature branch that introduces a failing unit test, and one that introduces an obvious bug (off-by-one in the sort). The tool must report the failing test and the reviewer must flag the bug. Both are removed afterward.

## 10. Rules

- Target repo: the internal AI Garage web repo. Never push to main, never force-push, never merge, never change hosting config. Preview deploys from branches are fine.
- The tool runs stock. Pinned upstream commit, clean working tree check (`git status --porcelain` empty), image digest recorded. Whatever identity stock commits as is recorded as a finding, not assumed.
- One session drives at a time. No parallel agent sessions on the same folder or board.
- Credentials: the evaluator creates and places them; the session verifies presence (`grep -c '^KEY=' .env` returns 1) and never prints values. Old tokens revoked when replaced. All eval tokens revoked at teardown.
- Approval protocol per section 4.
- Every step's verification block must pass before the step is done.
- Before every commit to the eval repo: `git grep -n -i -E "<scrub list>"` returns nothing, `git log --format='%an %ae'` shows only role identities, and a secret scan (`gitleaks detect` or `grep -E 'sk-|ghp_|github_pat_'`) returns nothing. The scrub list (names, handles, emails) lives outside the repo.
- Preserve before destroying: export PR metadata, diffs, check results and branch SHAs to `evidence/` before closing or deleting anything.
- Every day ends with `EOD-NOTE.md` in plain sentences.
- Evidence manifest: every score links to an entry in `evidence/MANIFEST.md` with an immutable copy (diff, exported JSON, log excerpt, redacted screenshot), its ID, and timestamp.

## 11. The eval repo

Private GitHub repo `adlc-eval`. Layout:

```
README.md                  what this is, the question, how to read results
PLAN.md                    this file
RUBRIC.md                  sections 4–7
FEATURE.md                 section 9 (acceptance checklists included; repo is private)
cascade/                   SETUP-LOG.md, BASELINE.md, MATRIX.md, REQUIREMENTS.md, SECURITY.md, LICENSE.md, SCORECARD.md, EOD-NOTE.md, evidence/, appendix-first-attempt/
openhands/                 PROCEDURE.md plus the same files
comparison/                RECOMMENDATION.md, DEMO-SCRIPT.md
```

Nothing from the Cascade checkout or `.env` goes in.

## 12. Order of work (Cascade)

No time budgets or time estimates. Measured time is logged for every run and phase.

Phase A. Baseline and reset
0. Create the eval repo and its folders first. Write `cascade/BASELINE.md`: target repo commit, tool upstream commit, worker image digest, model id, enabled agents, router config hash, board template (list and label names). Verification: file exists with every field non-empty.
1. Evaluator: mint a fresh Trello token and a reviewer GitHub account (a plain account, no personal data in its profile, added as collaborator), place both tokens in `.env`, revoke the old Trello token. Session verifies each key line exists once. Verification: `grep -c` returns 1 for each; no values printed.
2. Preserve then clean: export PR #23 and #24 metadata and diffs to `cascade/appendix-first-attempt/`; then close both PRs and delete their branches. Move the Sep 1 log and scorecard into the appendix, scrubbed. Verification: files exist; `gh pr list` shows none open; scrub grep returns nothing.
3. Reset the tool to stock: `git checkout` the pinned commit, `git status --porcelain` empty, rebuild the worker image, record its digest. Verification: clean tree; digest in BASELINE.md; a dry run in a scratch container prints the git author it would use, recorded as a finding.
4. Preflight, exact checks: `curl <router>/health` returns `status: ok`; webhook list shows exactly one GitHub hook and one Trello hook pointing at the current tunnel URL; project config shows model `claude-sonnet-5`, engine `claude-code`, SCM triggers empty (merge toggle off), Trello label mapping has no `auto` key; board has fresh cards only, no labels attached. Verification: each command's output pasted into the log.
5. Extensibility spike: find the supported way to add an agent without forking. Record the mechanism or its absence. Decides whether step 11 runs.

Phase B. Coding benchmark
6. Enable implementation only. For each quick story: fresh card in Backlog, evaluator drags it to To Do, session observes only, records timestamps, PR, diff, changed files, cost. Fill row 4 (all three), 5, 7b, and log hosting behavior for the 7a rule. Verification per story: PR link, checklist result, changed-files audit.

Phase C. Full lifecycle
7. Enable planning, splitting, backlog-manager, review, respond-to-review, respond-to-pr-comment, respond-to-ci. Reviewer token in the Reviewer slot. Record the reviewer's configuration (process, model, trigger). Verification: agent list output.
8. One card with the feature prompt. Let planning and splitting run. Evaluator approves at each gate and logs the gate with a timestamp. Fill rows 1, 2, 3 via JUDGMENT REQUIRED.
9. Let backlog-manager feed the stories. Per story: rows 4, 5. Then rows 6, 7, 8, 9. Run the two negative controls. Verification: transition table complete; negative-control outcomes recorded.
10. Extensibility test per row 10 (skip if step 5 found no mechanism).

Phase D. Checks and write-up
11. `SECURITY.md`: permissions granted, where secrets are readable, what the agent can execute, branch protections, data sent to providers. `LICENSE.md`: source license, dependency licenses (`license-checker` or equivalent), trademark, attribution, hosted-use terms; conclusions marked "counsel to confirm."
12. Finalize: MATRIX.md and REQUIREMENTS.md were filled during the run; this step is a review pass and the verdict.

Phase E. OpenHands
13. Before any setup: research and write `openhands/PROCEDURE.md` mapping every step above to the OpenHands equivalent (how it takes work items, how it opens PRs, where its reviewer and planner equivalents are or are not, its extension mechanism, how cost is read). Same feature, same quick stories, same checklists, same model and budget, fresh cards, fresh branches. Evaluator approves the procedure before Phase A for OpenHands begins. Cold setup timed from a clean clone.

Phase F. Comparison and demo
14. `RECOMMENDATION.md`: verdict per tool, what each tool would need added, assumptions, what the evaluation cannot say (single run, one task class, one evaluator, tool order effects). `DEMO-SCRIPT.md`: rehearsed once from a clean state and recorded.
15. Teardown: revoke all eval tokens, remove webhooks, stop containers, confirm with `gh api` and the tool's webhook list.

## 13. Prompt for the executing session

Paste into a fresh Claude Code session on the Mac, in `~/cascade-eval`:

> Read `EVAL-PLAN.md` in full first. It is the plan; do not re-derive it. This session executes Phases A through D for Cascade only, one numbered step at a time, in order. For each step: do it, run the verification block written in the plan, paste the evidence into `SETUP-LOG.md` with ISO 8601 timestamps, then pause and wait for me to type "go" before the next step. Also pause before any action that changes the repo, the board, credentials, or starts a run. Silence is not consent. Before scoring any matrix or requirements row, print `JUDGMENT REQUIRED: <row>` with the evidence and your proposed score, and wait for my score. Follow section 10 exactly: stock tool with pinned commit and clean tree, one session, no secrets printed, no personal names in any file bound for the eval repo, scrub and secret scans before every commit, preserve before destroying. Apply the two-failure rule from section 4: score and continue, do not abort. Subagents may read and summarize only. Fill `MATRIX.md` and `REQUIREMENTS.md` as evidence lands. Keep a `DECISIONS.md` listing every choice you made that the plan did not specify, with the reason. End the day by writing `EOD-NOTE.md`. Start with Phase A step 0.
