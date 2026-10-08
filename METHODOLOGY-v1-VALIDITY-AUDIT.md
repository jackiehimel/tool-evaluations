# Evaluation methodology v1 — validity audit

Date: October 2026

Status: retrospective, non-scoring audit of the frozen v1 protocol. This document does not change any historical evidence, score, or verdict. It does not authorize a rerun. Any later score correction requires a new immutable evidence record and its own `JUDGMENT REQUIRED` gate.

## 1. Audit question

The audit asks whether v1's hidden checks measured requirements the evaluated tool could know from:

1. the visible task prompt;
2. an accessible repository convention or framework rule;
3. a predeclared product-level workflow control.

A hidden verifier may test a visible requirement without revealing the exact assertion. It may not introduce a new required behavior, force one compliant implementation path, or move a criterion from another lifecycle stage into the coding score.

The classifications used below are:

- **Supported:** the required behavior is visible or follows directly from an accessible convention.
- **Derived verification:** the check samples or tests a visible behavior without adding a requirement.
- **Protocol control:** a predeclared evaluation or product-workflow condition, not a task-semantic requirement.
- **Narrow:** the check rejects reasonable implementations that satisfy the visible requirement.
- **Wide:** the check imports another lifecycle stage into the task's acceptance result.
- **Hidden requirement:** the check adds a requirement the tool was not given and could not reliably infer.

## 2. Changelog feature checklist

The visible prompt supports these hidden checks:

- **Route exists:** Supported. The prompt explicitly requires `/changelog`.
- **Navigation link exists:** Supported. The prompt explicitly requires a Changelog link in the portal navigation.
- **Combined feed and ordering:** Supported. The prompt requires one combined feed, newest first, with ties ordered by agent name.
- **Three edge cases:** Supported. No updates, same-date ordering, and missing author behavior are explicit.
- **Data-function tests cover the three cases:** Supported. Both the tests and cases are explicit.
- **No raw colors:** Supported. “Use design tokens only” states the requirement.
- **Full check suite passes:** Supported. The prompt explicitly requires the page to build and pass the full suite.

One check is defective:

- **Changes limited to `app/changelog/`, `lib/`, `components/portal-nav.tsx`, tests, and `lib/*.test.ts`: Hidden requirement and narrow implementation constraint.** The visible prompt does not disclose this allow-list. No cited repository convention establishes it. A compliant implementation could reasonably add a dedicated component or update related documentation. The broad allowance for all of `lib/` also does not map cleanly to the task's semantic scope.

The hidden-path rule therefore cannot support a corrected claim that editing `docs/architecture.md` was a failure to follow the visible feature request. A changed-files audit may still identify the edit as an observed side effect, but the exact allow-list was not a valid hidden requirement.

## 3. Quick-story checklists

### Story 1 — page title

- **PR on a new branch, never `main`, by the implementer identity:** Protocol control. It was predeclared for the product workflow, but it is not a semantic requirement of the visible story. It may assess branch and identity controls, not whether the title change itself is correct.
- **Only the title string in `app/layout.tsx` changes:** Supported. The prompt names the exact location and says not to change anything else.
- **CI is green:** Wide if included in the coding result. It is valid evidence for the unit-test/check stage and may be reported beside coding, but it should not duplicate or alter the coding outcome.
- **Preview builds and shows the title:** Wide if included in coding. It is valid deployment and smoke-test evidence.

### Story 2 — site footer

- **PR on a new branch with no unrelated files:** The branch is a protocol control; “no unrelated files” is supported by the task's bounded request.
- **A new footer component plus layout wiring:** Narrow in its component requirement. The prompt requires the footer below page content in the root layout and points to an existing component pattern, but another implementation could satisfy the visible behavior without creating that exact component boundary.
- **Design tokens and the navigation's visual language:** Tokens are supported explicitly. “Matches the nav's visual language” is directionally supported but subjective and had no v1 anchor for consistent judgment.
- **CI and build pass:** Supported as check-stage evidence because the prompt names the full command sequence; wide if reused to lower the coding outcome.
- **Footer appears on `/`, `/library`, and `/submit`:** Derived verification. Sampling three routes tests the visible “every page” requirement without adding a new behavior.
- **A reviewer persona posts a review if available:** Wide. This belongs to the review stage and is not part of implementing the footer.

The scorecard prompts about reading repository conventions and running checks are useful process observations. They are not additional feature acceptance requirements.

### Story 3 — per-route titles

- **PR on a new branch:** Protocol control.
- **Changes limited to six route files or their layouts:** Narrow and implementation-specific. The prompt names six routes and directs the tool to the installed framework documentation, but it does not prohibit a compliant shared helper or another framework-supported structure.
- **All six preview titles are correct and `/` is unchanged:** Supported. These behaviors are explicit; checking them on a preview is derived verification.
- **CI and build pass:** Supported as check-stage evidence because the prompt says to run the full suite; wide if reused to alter coding.
- **A reviewer persona posts a review if available:** Wide. It belongs to the review stage.
- **Client-component handling is correct:** Derived verification of the explicit route-title behavior under the accessible installed framework documentation. The implementation technique itself should not be prescribed if the rendered behavior and framework constraints are satisfied.

## 4. Consequence for Cascade row 4

Cascade row 4 was lowered to `Partly` because one run edited `docs/architecture.md` outside the hidden Changelog allow-list. The evidence also records that:

- the approved plan explicitly included that documentation edit;
- the implementation followed the plan;
- the first head met the story's functional checklist;
- no human corrective work occurred during the implementation run.

The historical `Partly` judgment remains part of the v1 record. For future comparison, however, that cell must be labeled **affected by a methodology defect**. It must not be used as evidence that Cascade failed a visible file-scope requirement. This audit proposes no replacement score.

The defect is decision-relevant because v1 takes the lowest result across multiple coding runs, while OpenHands received one differently packaged coding run. A corrected comparison cannot treat those row-level labels as matched evidence of coding quality or reliability.

## 5. `Partly` does not have one historical meaning

V1 defines `Partly` as bounded corrective work: one clarified rerun or no more than one rewritten section. Historical use is broader:

- rows 1 and 3 use it for an incomplete initial output with zero corrective work;
- row 4 uses it for a hidden-scope finding with zero corrective work;
- rows 7b, 9, and 10 use it for partial capability coverage;
- the definition also permits an initially unacceptable output that becomes acceptable after bounded correction.

The labels are therefore not comparable as a measure of human correction burden. Historical labels remain unchanged, but future records must expose at least:

- initial outcome;
- criterion coverage and reason for any gap;
- assistance or corrective work;
- recovery outcome;
- product, environment, or external-control cause.

Documented absence, observed execution failure, and a capability requiring source modification may retain a common categorical outcome where appropriate, but their reasons must remain distinct.

## 6. Experiment validity is separate from product outcome

A trial is invalid only when its evidence cannot answer the registered question, such as:

- acceptance answers leaked before execution;
- the trial started from the wrong repository or product state;
- the grader, reset, or control was broken;
- undeclared assistance destroyed the intended comparison.

The following are not by themselves invalid experiments:

- a product crash or permission failure;
- missing product-native traces;
- uncontrolled product automation;
- a product's inability to complete a stage;
- an external block that is itself correctly evidenced.

Those are product outcomes, observability gaps, or control findings. The Changelog scope defect affects interpretation of one criterion; it does not erase the underlying run evidence.

## 7. What the existing evidence can support

The completed runs can support attributed capability observations and observed single-run outcomes. They do not support claims about:

- coding reliability or throughput;
- productivity;
- multi-customer operation;
- broad review quality;
- adversarial security resistance;
- production release management.

The main confounds are one evaluator, tool-order effects, one task family, unequal run counts, unequal task packaging, and model or configuration differences. Missing native traces are disclosed as observability limits rather than repaired with evaluator-created credit.

## 8. Required treatment going forward

- Keep the v1 source documents and judgments frozen.
- Treat the Changelog allow-list as a disclosed methodology defect, not a silently repaired rule.
- Keep hidden verifier mechanics, but make every required behavior visible or traceable to an accessible convention.
- Keep protocol controls and lifecycle-stage evidence separate from feature acceptance.
- Accept multiple compliant implementations unless an implementation constraint is visible and decision-relevant.
- Do not infer a score change from this audit. Present new evidence first and use a separate `JUDGMENT REQUIRED` gate.
- Classify existing comparison cells separately as matched-comparable, capability-only, documented-only, unverified, or affected by a methodology defect.
