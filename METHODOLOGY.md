# ADLC tool evaluation methodology v2

Version: 2.0 draft
Date: October 2026
Status: prospective protocol

This methodology applies to future evaluation work and to the interpretation of final comparisons. It does not replace the frozen v1 protocol, change historical judgments, or authorize any new run. Existing results remain v1 results and must be labeled as such.

## 1. Purpose and boundaries

The evaluation answers two separate questions:

1. What can the declared product configuration demonstrably do?
2. Is that capability suitable for the declared backbone or specialist role?

Implementation strategy is decided afterward. Stock use, supported configuration, composition, supported extension, a source fork, building a missing capability, and retaining the baseline are distinct choices.

This is a decision-focused capability evaluation. Unless a separately approved study is designed for a stronger claim, it is not a reliability, productivity, throughput, security-certification, or multi-customer benchmark.

V2 retains:

- the Track A and Track B split;
- the ten lifecycle stages;
- stock-only attribution;
- immutable evidence records;
- separate evidence and judgment gates;
- the two-failure stop;
- separate tool runtime, evaluator activity, waiting, tokens, and cost;
- one approval for one protocol step.

V2 does not add a universal Discovery stage, weighted lifecycle scores, a 100-point score, or a fixed adoption percentage.

## 2. Evaluation unit

Every result describes one declared evaluation unit, not a product name in the abstract:

- product, edition, release, and commit or build identifier;
- deployment mode;
- model and relevant model settings;
- product configuration;
- supported integrations used;
- permission and credential policy;
- relevant infrastructure and network boundary;
- operator;
- target repository revision and starting state;
- evaluation window when a managed service cannot be pinned.

A material change to the evaluation unit creates a new result. Results from different units may be compared only at the claim level their differences permit.

## 3. Classify the product before testing

### Track A — backbone or lifecycle candidate

Use the common ten-stage matrix when the product claims to be an end-to-end delivery system or a plausible backbone.

The question is:

> Which lifecycle stages does this declared configuration cover, what outcomes were observed, what controls and assistance were required, and can it host supported extensions?

### Track B — specialist or operator tool

Use focused differentiator tests when the product is a reviewer, coding runtime, cockpit, interface, or other component rather than a lifecycle orchestrator.

The question is:

> At which declared lifecycle step does this tool add a demonstrated capability, and what paired evidence supports any claim that it improves the baseline?

A Track B tool receives no artificial end-to-end score or backbone verdict. Without a paired baseline, its result is a capability or fit observation, not evidence that it is materially better.

Composed systems may be evaluated, but the composition is the evaluation unit. Credit from a composition is not reassigned to an individual stock product.

## 4. Requirement and verifier contract

Before a run, register each requirement with:

- a stable requirement ID;
- the required behavior;
- priority: nonwaivable, required, or observational;
- delivery mechanism: visible task text, accessible repository convention, declared product-default test, or evaluator protocol control;
- lifecycle stage;
- acceptance evidence;
- whether the verifier mechanics are hidden;
- the allowed assistance and recovery envelope;
- any veto consequence.

Hidden verification is allowed. Hidden requirements are not.

A hidden verifier may test a visible behavior without disclosing its exact assertion or fixture. It may not:

- add a behavior absent from the visible requirement and accessible conventions;
- require one implementation when several satisfy the behavior;
- use a criterion from another lifecycle stage to lower the current stage;
- reward or penalize knowledge available to only one product.

Protocol controls such as branch policy, identity separation, and evaluator approvals are recorded as controls. They are not silently treated as feature semantics.

Subjective criteria require prospective anchors and examples. If no anchor was registered, report the observation without pretending it is a calibrated score.

## 5. Common ten-stage matrix

Track A retains these stages:

1. **BRD:** Produce the declared requirements artifact, including scope, exclusions, assumptions, acceptance criteria, and open questions when those items were requested by the registered requirement contract.
2. **Stories:** Create traceable work items with acceptance criteria that collectively cover the requirement.
3. **Architecture:** Before implementation, identify files or components, data flow, applicable conventions, and at least one considered alternative when required.
4. **Coding:** Produce the requested change on an allowed branch, satisfy the visible behavior, and avoid unrelated side effects.
5. **Unit tests and checks:** Add or update required tests; report the actual lint, typecheck, test, and build results; respond correctly to a validated failing-test control.
6. **Review:** Use the declared review identity and process, provide evidence-based findings with severity, handle a valid finding, and exercise validated defective and clean controls.
7. **Deploy:** Record separately whether the product initiates or manages deployment (7a) and whether it observes and reports deployment state (7b).
8. **Smoke test:** Check the permitted deployed target and report the observed result through the declared work channel.
9. **Orchestrator:** Coordinate and evidence the declared handoffs, gates, state transitions, side effects, and per-run cost from intake through verification.
10. **Extensibility:** Use a supported mechanism rather than a source fork to define the registered read-only extension, exercise its approved triggers, and verify its effective permissions.

Rows are evaluated only against registered requirements. A capability the product does not claim may still be a customer gap, but product-role fit and customer need must not be collapsed into one statement.

## 6. Trial and outcome record

A **trial** is one execution of a registered task from its declared reset state. Product-native retries, harness retries, human clarification, corrective work, and evaluator repair are separate events inside the record.

Every trial reports:

- task and requirement IDs;
- evaluation-unit identifier;
- starting-state evidence;
- initial outcome;
- each retry or recovery event;
- final outcome;
- assistance;
- control status;
- evidence pointers;
- tool runtime, evaluator activity, waiting, tokens, and cost.

Use the same outcome scale for initial and final outcomes:

- **Does it:** At that observation point, all elements of the registered criterion are met.
- **Partly:** Some required elements are met and at least one remains unmet.
- **Doesn't:** The criterion is not met within the registered envelope.
- **Blocked:** An external condition prevents the test and the same condition is evidenced independently of the product.
- **Not tested:** The criterion was not attempted; a reason is required.

`Doesn't` requires reason metadata:

- `documented-absence`;
- `observed-failure`;
- `source-change-required`;
- `quality-gap`;
- `control-violation`.

Assistance is recorded separately:

- none;
- expected gate action;
- clarification;
- product-native recovery;
- evaluator corrective work;
- evaluator repair or replacement;
- vendor assistance.

Control status is also separate: `not-applicable`, `not-run`, `passed`, `failed`, or `contaminated`. A product failing a valid control is an outcome. It changes only that registered control or lifecycle-stage outcome unless it independently demonstrates failure of another registered criterion. A broken or contaminated control affects experiment validity only when it prevents the registered question from being answered.

An initial `Partly` that remains `Partly` is distinguishable from an initial `Partly` that reaches `Does it` after correction. A recovered result never erases the initial outcome or the assistance that enabled recovery.

Show every registered trial. Do not use a median, average, best result, or lowest categorical result as the sole decision input. Ordinary variation is reported as variation; a small number of trials does not establish reliability.

The two-failure stop remains: stop the step after two total failed attempts, including the initial attempt, unless the frozen protocol explicitly defines otherwise. Record the evidence and continue with independent work unless a safety, authority, or registered USD-cap stop applies.

## 7. Experiment validity

Validity is separate from product outcome.

Assess validity per requirement and claim. Mark the whole trial invalid only when no registered question remains answerable; retain unaffected evidence.

A requirement, claim, or whole trial is invalid only when its evidence cannot answer the registered question, for example:

- hidden answers were exposed before execution;
- the repository, product, or reset state was wrong;
- the grader or control was broken;
- undeclared assistance destroyed the intended comparison;
- evidence was attributed to the wrong product.

An invalid evidence unit is unscored and retained with its reason. Invalidity is not a favorable exclusion and does not convert to `Blocked`.

These are product outcomes or observability findings, not automatic invalidity:

- crashes;
- permission failures;
- missing native traces;
- uncontrolled product automation;
- inability to complete a stage;
- an independently verified external block.

## 8. Evidence and provenance

Every factual claim is labeled:

- directly observed;
- reported by current product documentation or pinned source;
- inferred, with the inference stated.

Every capability claim also records provenance:

- `stock-native`;
- `supported-configuration`;
- `supported-extension`;
- `composition`;
- `evaluator-built`;
- `source-modification`;
- `absent`.

Evaluator-built replacements and source modifications may be useful diagnostics, but they do not earn stock-product credit.

Evidence remains immutable. Corrections use a new evidence ID or an explicit supersession entry. Required evidence depends on the row and may include:

- produced artifacts and work-item exports;
- complete diffs, branch and commit identifiers, and changed-files audits;
- local and CI check output;
- review objects and comments;
- deployment and smoke-test records;
- run configuration and effective permissions;
- available product-native events, logs, and user-visible transcripts;
- timestamps, tokens, cost, and assistance records.

Do not require private chain-of-thought or raw sensitive prompts. Absence of a transcript is an observability gap when the outcome can be verified through independent artifacts.

Normalized evaluator records support auditability. They do not count as product-native observability.

## 9. Handoff ledger

For each claimed coordinated handoff, record the available product evidence for:

- source actor;
- destination actor;
- trigger;
- correlation or run ID;
- input artifact;
- output artifact;
- requirement IDs;
- human or policy gate;
- ISO-8601 timestamp;
- state and result;
- side effects;
- evidence pointer.

Credit only transitions the evaluated unit coordinates. A chronological evaluator narrative cannot substitute for a missing product transition when the claim concerns native orchestration.

## 10. Diagnostic continuation after an upstream failure

An upstream failure may prevent testing a later independent capability. A frozen evaluator-provided reference input may be used only when:

- the diagnostic is separately labeled and approved;
- the reference artifact and its origin are recorded;
- the downstream stage can be evaluated independently;
- the result receives no chained or end-to-end credit.

The original trial remains failed, partial, blocked, or invalid as its evidence supports. The diagnostic fixture does not repair it.

## 11. Comparability

Classify each claim or criterion separately:

- **matched-comparable:** the requirement, starting state, task packaging, assistance policy, relevant controls, and evaluation unit are sufficiently matched for the stated claim;
- **capability-only:** an observed result that demonstrates capability but does not support a relative performance or reliability claim;
- **documented-only:** supported by current documentation or pinned source but not exercised;
- **unverified:** claimed but not evidenced;
- **methodology-defect:** affected by a requirement, verifier, grader, or interpretation flaw.

Record a methodology defect as an additional flag when unaffected evidence remains. It becomes the comparison classification only when the defect prevents the claim from being interpreted. It does not erase unaffected capability evidence.

Two comparison levels must remain explicit:

- **bundle versus bundle:** each product with its declared model, configuration, and operating envelope;
- **orchestrator versus orchestrator:** only where model, material configuration, task packaging, permissions, and relevant infrastructure are matched.

Pre-register the number of trials needed for the intended claim. Equal single trials can support a narrow matched capability comparison. Reliability, consistency, and distribution claims require a separately designed study; repeating a few trials does not establish them.

Existing Cascade and OpenHands runs may support attributed capability observations claim by claim. Their unequal runs and task packaging do not support coding-reliability or latency-distribution comparisons.

## 12. Focused controls

### Review controls

Future review comparisons use:

- validated planted defects representing the intended review boundary;
- a clean control;
- adjudication of unmatched findings rather than automatically counting each as false.

Record detection, severity, evidence, and whether the finding was actionable. One planted defect does not establish broad review quality.

### Security controls

Security probes require their own approval. They must be:

- derived from the declared threat model;
- non-destructive;
- run in a disposable environment;
- based on synthetic canaries and evaluator-controlled destinations;
- limited to the permissions and boundaries the product claims.

Relevant probes may include untrusted repository or ticket instructions, trigger authorization, approval enforcement, task-scoped credentials, egress, and promised read or write restrictions.

OWASP categories may organize coverage; they do not turn the result into a certification. Findings record severity, exploitability, affected boundary, evidence, and demonstrated mitigation. Only a predeclared nonwaivable security or authority violation automatically vetoes suitability.

### Resilience controls

Resilience probes also require separate approval and must match the evaluated architecture. Candidate scenarios include duplicate triggers, interruption, timeout after a side effect, cancellation, malformed tool output, and USD-cap enforcement.

## 13. Suitability and strategy

The final recommendation answers two questions separately:

1. Is the evaluated unit suitable for the declared backbone or specialist role under the registered nonwaivable requirements?
2. Which strategy is supported by the evidence: stock or configured use, supported extension, composition, source fork, building a missing capability, or retaining the baseline?

The standing Track A suitability rule is:

- **Suitable:** rows 4, 5, 9, and 10 are `Does it`; rows 2, 3, 6, and 7b are at least `Partly`; rows 1 and 8 are at least `Partly` or validly `Blocked`; required evidence is present; and no nonwaivable requirement fails.
- **Conditionally suitable:** every `Suitable` threshold is met except that one or more of rows 4, 9, or 10 is `Partly`; none of those rows is `Doesn't`, `Blocked`, `Not tested`, or invalid; each gap has a declared strategy; and no veto applies. `Partly` on rows 4, 9, or 10 never maps to `Suitable`.
- **Unsuitable:** row 4, 9, or 10 is `Doesn't`, another mandatory threshold is missed with sufficient evidence, or a nonwaivable veto applies.
- **Inconclusive:** a decision-critical row is `Blocked`, `Not tested`, invalid, or evidence-missing.

A frozen per-run requirement contract may tighten this rule but may not loosen it.

A missing capability is not by itself a business case to build it. A permissive license is not by itself a reason to fork.

A single demonstrated nonwaivable security, authority, or policy violation may veto suitability when that consequence was registered before the run. Ordinary task failure is reported in the trial record and does not become a reliability claim.

Historical Adopt, Fork, Build, Reject, and Inconclusive labels remain v1 results. V2 reporting may cite them as historical decisions but must not silently recompute them.

## 14. Execution controls

- Pin the evaluation unit and verify the starting state before a run.
- Use one active session against a shared repository, board, pull request, or other mutable target.
- Never push to `main`, force-push, merge, enable auto-merge, or change hosting controls as part of a score.
- Keep credentials evaluator-owned and task-scoped; verify presence without printing values.
- Register a USD cost cap before every run and stop the run when it is reached. Record a cost-cap stop as an outcome, not an invalidity. Apart from safety and authority stops, automatic limits are expressed only as attempt counts or USD caps.
- One explicit approval authorizes one individual protocol step, credential action, external mutation, agent run, commit, or teardown action.
- Report the result of that step before requesting the next approval.
- Before each `JUDGMENT REQUIRED` gate, a separate read-only, non-scoring reviewer with access only to the proposed scores and the evidence folder audits each row and marks it `supported`, `unsupported`, or `evidence-missing`. Record the audit result as evidence and show it to the evaluator at the gate.
- Present evidence before every separate `JUDGMENT REQUIRED` scoring gate.
- Keep subagents read-only, credential-free, non-scoring, and non-mutating.
- Preserve evidence before cleanup, closure, deletion, rollback, or teardown.
- Run the external scrub-list, role-identity, secret, and internal-consistency checks before committing evaluation material.
- Use role identities in the evidence repository.
- Record protocol deviations and their consequences.
- Do not rotate credentials or tear down live evaluation state without explicit authorization.

## 15. Reporting and claim boundaries

Final reporting must:

- show every trial's initial and final outcomes;
- disclose assistance, controls, operator, and provenance;
- distinguish observed, documented, inferred, and unverified claims;
- distinguish matched comparison from capability-only evidence;
- keep stock capability separate from supported extension, composition, evaluator-built work, and source changes;
- keep setup, runtime, evaluator activity, waiting, tokens, and cost separate;
- disclose evaluator count, tool order, task family, unequal packaging, unequal run counts, and model or configuration confounds;
- report decision-critical evidence gaps without silently filling them;
- state which requirement or finding could change the recommendation.

Without a separately approved study, do not claim:

- coding reliability;
- productivity improvement;
- throughput;
- multi-customer performance;
- broad review quality;
- adversarial security resistance;
- production release-management capability.

## 16. Versioning and use with v1 evidence

Freeze the applicable protocol, requirement contract, controls, and claim scope before each new run. Methodology changes create a new version; they do not rewrite the rules under completed evidence.

V1 scores and the v1 verdict remain preserved as v1 results; v2 adds only per-claim comparability and claim-boundary labels, so no v1 score or verdict is re-expressed, recomputed, or re-checked under v2: the Cascade coding row keeps its v1 `Partly` score with the `methodology-defect` flag, and the `Fork` verdict remains a dated v1 decision.

For existing v1 evidence:

- preserve the historical score and judgment;
- apply the v1 validity audit when interpreting the result;
- add comparability and claim-boundary metadata without rescoring;
- require new immutable evidence and a separate judgment gate for any proposed score correction;
- keep completed Cascade and OpenHands phases closed;
- require any proposed new run to be decision-critical, governed by its own frozen protocol and registered USD cap, and separately approved.
