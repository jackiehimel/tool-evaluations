# tool-evaluations

Evidence and results for evaluations of agentic development tools: coding agents, multi-agent frameworks, orchestration backbones, cockpits, and supporting infrastructure. The objective is to identify **demonstrable, commercially useful agentic capabilities**, not to assume that a proprietary end-to-end software factory must be built.

## What the evaluations are for

The potential customer-facing offerings include:

- **Reusable agents and agentic workflows:** useful solutions that can be configured, deployed, and supported.
- **Application maintenance and diagnostics:** modular agents that inspect or monitor existing applications; remediation may be a separate service.
- **Customer-specification-to-prototype delivery:** an AI-assisted way to turn a bounded customer request into independently verified working software.
- **An integrated AI-powered development lifecycle:** a possible broader offering, potentially composed from existing tools and custom components.
- **Tool adoption and implementation services:** where configuring, integrating, and operating existing platforms creates customer value.

These are potential paths, **not confirmed product decisions**. Whether a future offering is proprietary software, a supported composition, or a professional service remains open. The ability to build a demo does not establish production readiness, commercial viability, ownership rights, or reliability.

**Near-term evidence goal:** demonstrate a bounded, customer-derived application slice using authorized synthetic data, independently verify the delivered behavior, and record the actual operator assistance, tool contributions, elapsed time, tokens, costs, limitations, and demo outcome. Do not substitute a static mockup for functioning software.

The ordered forward-evaluation register is in [comparison/FORWARD-EVALUATIONS.md](comparison/FORWARD-EVALUATIONS.md). The next candidate is **Cezar**. Its existing focused tests remain registered; a distinct customer-demo *reporting record* is in [tools/cezar/CUSTOMER-DEMO.md](tools/cezar/CUSTOMER-DEMO.md).

## What belongs in this repository

Going forward, this repository is for **approved, sanitized evaluation records and findings**, suitable for technical review and later comparison:

- Evaluation-unit identifiers: exact product/version, declared model and configuration, target starting revision, and evidence boundaries, with sensitive details removed.
- What was actually observed: results, independent verification outcomes, human assistance, limitations, measured time and cost, and evidence references.
- Capability attribution: distinguish stock product, supported configuration, composed system, underlying coding agent, and evaluator-added work.
- Comparisons constrained to genuinely comparable claims, without manufacturing a universal winner or unsupported reliability claims.

**Keep outside the repository:** internal evaluation orchestration and Claude Code skills/subagents; private runbooks and demo-recording preparation; original customer specifications or proprietary quotations; raw customer records; credentials, personal identifiers, account identifiers, and secrets. Confidential source requirements and detailed test mechanics remain in a separate local-only workspace. Publish sanitized acceptance-result summaries only after review and approval. Do not place source customer documents here, even in this private repository.

**Existing-file boundary:** This repository already contains `METHODOLOGY.md`, earlier methodology files, `AGENTS.md`, and tool-specific `PROCEDURE.md` / run prompts. They are preserved for historical traceability and ongoing compatibility; **this update does not add new private execution methods or remove the existing files**. Their eventual migration or retention needs a separate, deliberate review. Deleting tracked material would not erase Git history.

## How to read the existing results

- `METHODOLOGY-v1.md`: historical procedure used for the September 2026 runs.
- `METHODOLOGY-v1-VALIDITY-AUDIT.md`: recorded methodological concerns affecting interpretation of v1.
- `METHODOLOGY.md`: prospective v2 methodology; currently marked *draft*. It does not retroactively replace v1.
- `tools/cascade/`: evaluated v1 record. Its historical **Fork** verdict is preserved as a dated v1 outcome, not a current platform recommendation.
- `tools/openhands/`: evidence is committed, but the evaluation is **not fully scored** and one extensibility test was not run. Do not infer a verdict.
- `comparison/COMPARABILITY.md`: claim-level boundaries for Cascade and OpenHands, including the Cascade coding methodology defect.
- `tools/cezar/PROCEDURE.md`, `tools/vercel-eve/PROCEDURE.md`, and `tools/cursor-automations/PROCEDURE.md`: previously registered focused tests, **not evidence that those tests passed**.
- `tools/_shared/tasks/`: frozen historical quick-story and Changelog fixtures. Do not overwrite or relabel them as the separate customer-derived prototype benchmark.

## Status of recorded work

| Candidate | Recorded status |
|---|---|
| Cascade | Historical v1 evaluation; preserve scores and documented caveats. |
| OpenHands | Historical evidence present; scores/verdict not confirmed; extension gap. |
| Cezar | Focused Track B procedure registered; **no committed execution evidence** as of this update. Separate customer-demo record opened, not run. |
| Vercel Eve | Focused procedure registered; no confirmed results in this repository. |
| Cursor Automations | Earlier focused procedure registered; outside the current ten-candidate sequence. |
| Other forward candidates | See the ordered register; absent results are not failed tests. |

All result claims require linked evidence. A tool's UI, documentation, or a generated PR does not by itself prove end-to-end delivery, product-native orchestration, security, or a sellable solution. Evaluator repairs do not become tool credit. Record untested and blocked areas explicitly rather than silently treating them as successes or failures.

**This repository update changes project framing and reporting readiness only. It does not authorize tool runs, amend frozen historical evidence, score untested work, or commit any customer material.**
