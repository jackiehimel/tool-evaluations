# ADLC tool evaluation methodology

This document records the evaluation approach established for Cascade, OpenHands, and tools that cover only part of the development lifecycle. It separates the common rules from each tool's procedure so results remain comparable without pretending that every product has the same shape.

## 1. Repository model

`adlc-eval` is the shared evaluation and evidence repository. It is not a source-code monorepo containing the products under test.

The repository holds:

- the common plan, rubric, frozen feature, and acceptance criteria;
- one folder per evaluated tool containing its procedure, baseline, decisions, findings, and immutable evidence;
- comparison material that uses only like-for-like evidence.

Product source checkouts, credentials, environment files, generated runtime state, and containers stay outside the evidence repository.

The repeatable structure is:

```text
adlc-eval/
  PLAN.md
  RUBRIC.md
  FEATURE.md
  EVALUATION-METHODOLOGY.md
  <tool>/
    PROCEDURE.md
    BASELINE.md
    SETUP-LOG.md
    DECISIONS.md
    MATRIX.md
    REQUIREMENTS.md
    FINDINGS.md
    SECURITY.md
    LICENSE.md
    SCORECARD.md
    EOD-NOTE.md
    evidence/
      MANIFEST.md
      <immutable evidence records>
  comparison/
    RECOMMENDATION.md
    DEMO-SCRIPT.md
```

Not every tool reached every planned file. This is the intended common structure, not a claim that all evaluations are complete.

## 2. First classify the tool

Before testing, decide which question the product can fairly answer.

### Track A: full ADLC or foundation candidate

Use the common ten-stage lifecycle matrix when the tool claims to be an end-to-end delivery system or a plausible backbone for one. Cascade and OpenHands used this track.

The question is:

> Which lifecycle stages does the stock tool cover, how well, at what observed cost and corrective effort, and can it host our own agents?

### Track B: specialist or operator tool

Use focused differentiator tests when the product is an interface, cockpit, reviewer, coding runtime, or other component rather than a lifecycle orchestrator.

The question is:

> Is there a specific lifecycle step where this tool does something materially better than the existing workflow?

Do not award end-to-end lifecycle credit for capabilities the tool does not claim. Do not spend runs retesting the underlying coding agent when the product's value is the layer around that agent.

Firehose used this track.

## 3. Common lifecycle benchmark

Track A evaluates ten rows.

1. **BRD:** From the frozen prompt, produce scope, exclusions, assumptions, acceptance criteria, and open questions.
2. **Stories:** Create traceable work items in the project-management tool, each with acceptance criteria that collectively cover the requirement.
3. **Architecture:** Before code is written, name files, components, data flow, repository conventions, and at least one considered alternative.
4. **Coding:** Open a pull request from a branch, never `main`, satisfy the frozen checklist, and avoid unrequested or out-of-scope changes.
5. **Unit tests:** Add or update tests where required; make lint, typecheck, test, and build pass; report a deliberately failing test.
6. **Review:** Use a separate review identity and process, rank findings by severity, fix a valid finding, and catch a deliberately injected bug.
7. **Deploy:** Score separately whether the tool initiates or manages deployment (7a) and whether it observes and reports the result (7b).
8. **Smoke test:** Check the deployed URL and report pass or fail on the work item or pull request.
9. **Orchestrator:** Record and coordinate the hand-offs from prompt through verification, including actor, timestamp, human gates, and cost per run.
10. **Extensibility:** Use a supported configuration, manifest, plugin, or SDK mechanism—not a source fork—to define a read-only repository-summary agent, run it on demand and on a schedule, and verify that it has no code-write permission.

Two additional questions are answered once per tool:

- What did the tool do that the target repository's existing CI/CD did not?
- Could stories and findings be exported to the customer's backlog? Only integrations actually exercised receive tested credit; the rest are marked documentation only.

## 4. Shared test material

Lifecycle tools receive the same frozen work:

- one Changelog feature covering requirements, decomposition, implementation, tests, review, and hand-offs;
- three small coding stories covering a page title, a site footer, and per-route titles;
- a hidden acceptance checklist;
- a failing-test negative control;
- an off-by-one sorting-bug negative control.

The feature prompt is visible to the tool. The evaluator's acceptance checklist is not.

The target repository, target revision, model, budget setting, and hosting constraints are recorded in the tool's baseline. Differences that cannot be held constant are disclosed rather than normalized away.

## 5. Scores

Each matrix row uses one of five scores.

- **Does it:** The output is accepted without a semantic change. Cosmetic edits are logged but do not lower the score.
- **Partly:** Corrective work was required, limited to one clarified rerun or rewriting no more than one section.
- **Doesn't:** The tool cannot perform the criterion, needs more correction than the Partly limit, or requires a source-code change.
- **Blocked:** An external condition prevented the test, with evidence that the same condition fails independently of the tool.
- **Not tested:** The capability was not attempted. A reason is required.

When a row has several runs, every run is shown and the row receives the lowest score.

Documented absence from a stock product counts as **Doesn't**. A capability that exists but was not exercised counts as **Not tested**. Evaluator-built replacements do not earn credit for the stock product.

After two failed attempts on one step, stop retrying, record the exact failure, score it Doesn't or Blocked as the evidence supports, and continue with the next independent step.

## 6. Evidence and judgment protocol

Every factual claim is one of:

- directly verified during the evaluation;
- reported by product documentation or source;
- inferred, with the inference labeled.

Every score must link to an immutable evidence record in the tool's manifest. Depending on the row, evidence includes:

- the produced document or work-item export;
- pull-request metadata, branch SHA, and complete diff;
- changed-files audit against the frozen scope;
- local and CI check results;
- review objects and comments;
- deployment and smoke-test output;
- transition records with actors and ISO-8601 timestamps;
- observed tool runtime, evaluator waiting time, tokens, and cost;
- configuration, permission, security, and license records.

Corrections create a new evidence ID or supersession entry. Existing evidence is not silently rewritten.

No row is scored as part of an execution approval. After evidence is presented, scoring pauses at a separate gate:

```text
JUDGMENT REQUIRED: stage N
```

The evaluator confirms or changes the proposed score. Subagents may collect and summarize evidence, but they do not score and do not perform credentialed or mutating evaluation work.

## 7. Execution controls

The controls are the same across tools unless a procedure records a justified exception.

- Test the stock product at a pinned release or commit and record the exact version.
- Verify a clean product checkout before the run.
- Drive only one session against a shared folder, board, or pull request at a time.
- Never push to `main`, force-push, merge, or change hosting configuration as part of a score.
- Keep credentials evaluator-owned, verify only their presence, and never print their values.
- Give each explicit approval to one individual protocol step only.
- Report the result of that step before requesting another approval.
- Preserve pull-request metadata, diffs, checks, and branch SHAs before closing, reverting, or deleting anything.
- Run the external scrub-list check, role-identity check, and secret scan before committing evidence.
- Keep personal identities out of the evidence repository; use role identities.
- Record deviations and decisions in `DECISIONS.md`.
- End each evaluation day with a plain-language `EOD-NOTE.md`.

## 8. Tool-specific procedures

### Cascade

Cascade received the full lifecycle procedure because it presented itself as the orchestration backbone.

1. **Baseline and reset:** Pin stock Cascade, record the worker image and configuration, establish fresh evaluation state, and verify integrations.
2. **Coding benchmark:** Run the three quick stories with implementation enabled and capture card-to-PR behavior, cost, diffs, scope, checks, and hosting results.
3. **Full lifecycle:** Enable planning, splitting, backlog management, implementation, review, review response, pull-request response, and CI response. Run the frozen Changelog feature through the available hand-offs.
4. **Negative controls:** Inject the failing test and sorting bug separately, preserve each change and response, and remove the controls afterward.
5. **Extensibility:** Define and run the read-only repository-summary agent through Cascade's supported definition mechanism and test the scheduling criterion.
6. **Assessment:** Complete the matrix, requirements fit, security review, license review, findings, scorecard, and verdict.

Multiple coding runs support a lowest-run aggregate for the coding row. They do not support broad reliability or throughput claims.

### OpenHands

OpenHands used the same rubric and frozen feature but a narrower runtime procedure. Source and documentation showed that the stock product lacked several lifecycle stages and the stage-9 hand-off orchestrator. Building those stages for the evaluation would have measured evaluator-written wiring rather than OpenHands.

The pre-registered procedure was:

1. **Research and map:** Map each matrix row to a stock OpenHands component or document its absence before installation.
2. **Cold setup:** Pin Agent Canvas and its stock runtime versions, start the backend-only product, record the baseline, and submit one successful no-op conversation.
3. **Consolidated foundation run:** Put the complete frozen feature into one labeled issue and use the stock issue-to-PR scheduled automation to produce one branch and draft pull request.
4. **Reviewer and controls:** Run the stock pull-request reviewer once, then inject the failing-test and sorting-bug controls sequentially. Pause the triggering automation after each intended response so an uncontrolled chain cannot form.
5. **Extensibility:** Implement the same read-only repository-summary test as a stock automation, exercising on-demand and scheduled execution.
6. **Documented-absence rows:** Score absent stock stages from current source and documentation. Do not create evaluator-built substitutes.
7. **Assessment:** Complete the same evidence, requirements, security, license, findings, and verdict records.

OpenHands received one consolidated coding run, while Cascade received several. Therefore, compare capability and observed outcomes, not latency distributions or reliability.

### Firehose

Firehose was treated as a human-in-the-loop cockpit for steering coding agents, not as a ticket-driven lifecycle orchestrator. Its evaluation focused on four differentiators:

1. **Parallel sessions:** Start three non-overlapping tasks in separate worktrees and judge whether the interface makes session purpose, state, switching, and per-session diffs clear.
2. **Smart Review:** Add a known edge case, run the product's review, and test whether it finds the planted issue and supports a review-to-fix-to-rereview loop.
3. **Question generation:** Provide deliberately incomplete product notes and judge whether the generated questions are answerable by a product manager and lead to an actionable specification.
4. **Agent-spawning API:** Determine whether one session can create and message other sessions, then ask it to split the three independent tasks and start them.

The decision question was not whether Firehose could replace Cascade. It was whether a person should steer multiple agents at a particular ADLC step and whether Firehose did that better than the existing interface.

## 9. Requirements-fit assessment

In addition to stage coverage, each lifecycle tool is checked for:

- command-line dependence in normal operation;
- a human approval at every required hand-off;
- use of the customer's own repository and project-management tool;
- visible tokens or cost per run;
- model-provider selection through configuration;
- observed operating work for a small supervising team;
- documented cold-start setup behavior.

Only observed integrations and behaviors receive tested credit.

## 10. Verdicts

Each Track A tool receives one verdict under rules fixed before the run:

- **Adopt:** The stock product meets the required backbone stages and operational requirements.
- **Fork:** The product is a viable backbone, but source changes are required and the license permits modification and redistribution.
- **Build:** A required backbone stage—coding, orchestration, or extensibility—is absent.
- **Reject:** Licensing blocks the intended commercial use, or a material security problem cannot be mitigated through configuration or hosting.
- **Inconclusive:** An early stop fired or too many rows remain untested.

A positive verdict also requires completed security, license, hosting, and requirements-fit checks. License conclusions remain subject to counsel where noted.

Track B specialist tools do not receive an artificial end-to-end verdict. Their result states the lifecycle step they improve, the evidence for that improvement, their operating constraints, and whether they should be included alongside the backbone.

## 11. Comparison rules

The final comparison must:

- compare identical lifecycle rows only where both tools were assessed against the same criterion;
- keep stock capabilities separate from evaluator-built integrations;
- keep setup effort, tool runtime, evaluator time, tokens, and dollars separate;
- distinguish observed results from documentation-only claims;
- disclose unequal run counts and tool-order effects;
- avoid reliability, throughput, or multi-customer claims from single-run capability demonstrations;
- report specialist-tool results beside the relevant lifecycle step rather than forcing them into an end-to-end ranking.

The output is a recommendation explaining which tool, if any, should be the backbone, which specialist tools add a useful layer, what capabilities remain missing, and what evidence the evaluation cannot provide.
