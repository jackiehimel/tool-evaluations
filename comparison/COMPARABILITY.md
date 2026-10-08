# Cascade and OpenHands comparability record

This record applies the claim-level labels in `METHODOLOGY.md` to existing evidence. It preserves every confirmed v1 score and verdict. It does not score OpenHands, recompute Cascade, or authorize a new run.

## 1. Evidence boundary

The sources used are:

- the frozen v1 plan, rubric, feature, and Cascade judgments;
- `METHODOLOGY-v1-VALIDITY-AUDIT.md`;
- `METHODOLOGY.md`;
- Cascade matrix, requirements, scorecard, and cited evidence;
- OpenHands procedure, baseline, decisions, setup log, manifest, and E-OH-000 through E-OH-032.

The labels are:

- **matched-comparable** — sufficiently matched for the narrow claim stated;
- **capability-only** — observed capability or outcome without a relative performance or reliability claim;
- **documented-only** — supported by pinned source or current documentation but not exercised;
- **unverified** — claimed or planned but not evidenced;
- **methodology-defect** — a flag on a claim affected by a requirement, verifier, grader, or interpretation flaw.

## 2. Preserved v1 results

- Every Cascade matrix score remains its confirmed v1 score.
- Cascade row 4 remains `Partly` and carries the `methodology-defect` flag for the hidden Changelog file allow-list. The flag does not erase the functional evidence and does not propose another score.
- Cascade's `Fork` verdict remains the dated v1 decision recorded in its scorecard and D-33.
- The historical uses of `Partly` do not have one assistance meaning, so cross-row or cross-tool comparisons may not treat that label as a common measure of correction burden.
- OpenHands has evidence records but no evaluator-confirmed matrix scores or final verdict. D-OH-4 and D-OH-5 are pre-registered decision rules, not completed judgments.

## 3. Lifecycle claims

### Stage 1 — BRD

- **Cascade:** capability-only. One planning run produced scope, exclusions, assumptions, and an open question; the v1 `Partly` score remains unchanged (E-010).
- **OpenHands:** documented-only for the absence of a stock planner or lifecycle BRD stage (E-OH-000, E-OH-001). A stock `prd` skill exists adjacent to that gap but was not exercised.
- **Cross-tool boundary:** no matched artifact-quality comparison. OpenHands has no confirmed row outcome.

### Stage 2 — stories

- **Cascade:** capability-only. The observed splitter created traceable cards and dependencies; the v1 `Does it` score remains unchanged (E-011).
- **OpenHands:** documented-only. The pinned stock catalog has issue consumers but no story splitter (E-OH-000, E-OH-001).
- **Cross-tool boundary:** observed capability versus documented absence, not a matched execution.

### Stage 3 — architecture

- **Cascade:** capability-only. The observed plan named files, components, flow, and conventions; the v1 `Partly` score remains unchanged (E-010).
- **OpenHands:** documented-only for the absence of a stock planning stage. SDK planning tools exist, but no corresponding stage was exercised (E-OH-000, E-OH-001).
- **Cross-tool boundary:** no matched architecture-output comparison.

### Stage 4 — coding

- **Cascade:** capability-only plus `methodology-defect`. Six observed coding runs produced feature-branch pull requests; all met their functional story checklist. The hidden Changelog path allow-list affected the aggregate v1 label, which remains `Partly` (E-006 through E-008, E-013, E-016, E-017; v1 validity audit).
- **OpenHands:** capability-only. One stock issue-to-PR run received the exact frozen Changelog prompt and opened a draft feature-branch pull request with the route, feed logic, navigation entry, and tests (E-OH-010, E-OH-011, E-OH-017). Independent local checks passed (E-OH-013).
- **Cross-tool boundary:** not matched-comparable for quality, latency, consistency, or reliability. Task packaging, starting revision, lifecycle path, and run count differ.

### Stage 5 — tests and checks

- **Implementation checks:** capability-only for both. Cascade recorded passing local and CI checks across its runs; the OpenHands feature pull request passed the full local suite and GitHub CI (Cascade E-006 through E-008, E-013, E-016, E-017; E-OH-012, E-OH-013).
- **Native failed-CI response:** matched-comparable only for the narrow presence-of-response claim. Both evaluations injected a deliberate failing test into the same target repository and observed GitHub CI fail. Cascade's enabled responder reported and repaired the failure; no OpenHands component observed or reported its failure, and GitHub CI receives no OpenHands credit (Cascade E-019; E-OH-019 through E-OH-024; D-OH-30).
- **Boundary:** this does not compare test-generation quality, overall row scores, or reliability.

### Stage 6 — review

- **Cascade:** capability-only. The reviewer caught a planted newest-entry drop while the suite remained green, and the response chain removed it and added a regression test (E-018).
- **OpenHands:** capability-only. The stock reviewer approved the clean feature head and later identified the planted `.slice(1)` defect precisely (E-OH-015, E-OH-025 through E-OH-032).
- **Cross-tool boundary:** the defect controls are not matched. Cascade's planted defect escaped the existing tests; the OpenHands control already failed four tests, making detection materially different. The evidence supports reviewer capability observations, not a broad review-quality ranking.

### Stage 7a — deployment initiation or management

- **Native deploy stage:** documented-only absence for both declared units (Cascade E-021 and findings; E-OH-000, E-OH-001).
- **Hosting outcome:** capability-only observations. Both feature paths encountered a hosting failure, but hosting behavior is not product-native deployment management and the configurations and commit identities differ (Cascade E-017; E-OH-012).
- **Cross-tool boundary:** no deployment-quality comparison.

### Stage 7b — deployment and pipeline observation

- **Cascade:** capability-only. With its CI responder enabled, it observed and reported a failing CI result; it did not report successful CI or deployment outcomes (E-019).
- **OpenHands:** capability-only negative evidence. GitHub CI produced success and failure records, but no OpenHands component reported them (E-OH-012, E-OH-021, E-OH-024, E-OH-027; D-OH-30).
- **Cross-tool boundary:** the narrow native failed-CI response claim is matched-comparable as stated under stage 5. Successful pipeline and deployment observation were not matched.

### Stage 8 — smoke test

- **Cascade:** documented-only absence of a stock deployed-URL checker; the v1 `Doesn't` score remains unchanged (E-021).
- **OpenHands:** documented-only absence of a stock lifecycle smoke-test stage; adjacent QA tooling was not exercised as this stage (E-OH-000, E-OH-001).
- **Cross-tool boundary:** no runtime smoke-test comparison.

### Stage 9 — orchestration

- **Cascade:** capability-only. The observed unit coordinated six handoffs with documented gaps; its v1 `Partly` score remains unchanged (E-020, E-022).
- **OpenHands:** documented-only absence of the requirements-to-verification lifecycle chain on the tested local backend (E-OH-000, E-OH-001). Automation records demonstrate scheduled issue-to-PR and review runs, not that lifecycle chain (E-OH-018).
- **Cross-tool boundary:** no matched end-to-end orchestration comparison. D-OH-5's pre-registered `Build` consequence is not a confirmed verdict.

### Stage 10 — extensibility

- **Cascade:** capability-only. A supported YAML-defined read-only agent ran on demand; native scheduling was absent and the schedule half was not run. The v1 `Partly` score remains unchanged (E-023).
- **OpenHands:** documented-only for supported skills, automations, SDK agents, and local scheduling (E-OH-000, E-OH-001). The planned E4 repository-summary test was not run, so exercised on-demand, scheduled, and effective-permission claims remain unverified.
- **Cross-tool boundary:** no matched extension execution.

## 4. Operational and requirements-fit claims

- **Own repository:** capability-only for both. Cascade exercised GitHub and Trello; OpenHands exercised GitHub issue-to-PR and review. No matched project-management integration claim exists.
- **Per-run cost visibility:** matched-comparable for the narrow claim that product-native records expose cost and token or iteration data for executed runs (Cascade E-020; E-OH-014, E-OH-016, E-OH-029). The figures are not comparable performance measures because the tasks and run packaging differ.
- **Model selection by configuration:** capability-only. Cascade accepted a configuration change without a run; OpenHands required the globally active Agent Server profile after two zero-cost launch failures (Cascade requirements record; E-OH-008).
- **Human approval at every handoff:** capability-only for Cascade's observed chain. OpenHands has no exercised end-to-end chain to compare.
- **Normal command-line dependence:** capability-only for Cascade's counted Phase C actions; unverified as a matched OpenHands operational claim.
- **Setup measurements:** capability-only observations. Prerequisites, procedure, product packaging, and correction paths differ, so elapsed setup results are not matched-comparable.
- **Small-team operation:** unverified for both as a comparative claim.
- **Security and license:** Cascade completed v1 records. Corresponding OpenHands assessment files are absent, so no cross-tool security, licensing, or suitability comparison is supported.

## 5. Control and attribution boundaries

- The Cascade-webhook review on OpenHands pull request #32 is contamination and remains excluded from OpenHands credit (E-OH-009, D-OH-25).
- The delayed OpenHands reviewer disable is a control deviation, not an uncontrolled response chain: one conversation and one review occurred; later polls produced no conversations (E-OH-032).
- GitHub CI outcomes are repository-CI evidence. They become product evidence only when a product component observes or reports them.
- Evaluator-authored injections and reverts receive no product credit.
- Product-native metrics support the recorded runs only; summed or elapsed values across differently packaged work do not support speed or efficiency rankings.

## 6. Claims this evidence does not support

The current record does not support claims about:

- coding reliability or latency distributions;
- productivity or throughput;
- broad review quality;
- end-to-end OpenHands orchestration;
- multi-customer operation;
- adversarial security resistance;
- production release management;
- relative setup speed;
- a v2 suitability answer or a new cross-tool verdict.

## 7. Decision-critical gaps

- OpenHands rows have not passed their individual v1 `JUDGMENT REQUIRED` gates.
- OpenHands E4 extensibility was not run.
- OpenHands security, license, requirements-fit, matrix, and scorecard records are incomplete or absent.
- The review controls differ materially and cannot support a reviewer ranking.
- OpenHands evidence files E-OH-000 through E-OH-033 are present in this repository. This does not change the unscored status, the unrun E4 extensibility test, or missing judgment gates.

No Cascade score or verdict change is proposed. No OpenHands score is entered here.

## 8. First judgment boundary

OpenHands stage 1 was identified as the first possible scoring boundary. E-OH-033 preserves the independent evidence audit of a provisional `Not tested` proposal; its result was `supported`. The evaluator stopped the gate because OpenHands scoring was not authorized in this phase and the applicable scoring protocol must be decided first. No OpenHands score or verdict is entered. Any OpenHands scoring is a separate, explicitly approved phase.
