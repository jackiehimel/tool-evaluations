# Cascade — results

**Verdict: Fork** (v1, confirmed 2026-09-03). Use it as the base; change the parts listed under "What a fork has to add."

Evaluation unit: mongrel-intelligence/cascade @ `aee88e20` (2026-08-25), stock, MIT, worker image `cascade-worker:local`, Claude Code engine on claude-sonnet-5, one evaluator, one target repo (the AI Garage web app), one run per step unless stated. Evaluated Sep 1–3, 2026 under protocol v1 (`METHODOLOGY-v1.md`). Scores are v1 results and are not re-scored under v2; the v2 column adds a comparability label per `METHODOLOGY.md` §11 (see `comparison/COMPARABILITY.md`).

## Scores

| # | Stage | Score | In one sentence | Evidence | v2 label |
|---|---|---|---|---|---|
| 1 | BRD | Partly | Implementation plan with scope, exclusions, assumptions, open question; no acceptance-criteria section. | E-010 | capability-only |
| 2 | Stories | Does it | Three traceable cards with acceptance checklists and dependencies; no human edits. | E-011 | capability-only |
| 3 | Architecture | Partly | Files, components, data flow before any commit; no considered alternative. | E-010 | capability-only |
| 4 | Coding | Partly | Six of six runs met their story checklist on a feature branch; the one Partly is a docs edit outside a file allow-list the tool was never shown. | E-006–008, E-013, E-016, E-017 | capability-only · **methodology-defect flag** |
| 5a | Tests written | Does it | Six tests covering the three required cases on the one story that required tests. | E-013 | capability-only |
| 5b | Checks pass | Does it | Lint, typecheck, test, build green on 6/6 PRs; planted failing test observed and reported. | E-006–017, E-019 | matched-comparable (failed-CI response only) |
| 6 | Review | Does it | Separate identity, ranked findings, inline comments, a valid finding fixed by the tool; planted sort bug caught. | E-014, E-018, pr-30/ | capability-only |
| 7a | Deploy — initiates | Blocked | Hosting provider blocked previews for the bot author on 6/6; the tool has no deploy step. | E-017 | documented-only absence |
| 7b | Deploy — observes | Partly | CI failure observed and reported with root cause; successes never reported. | E-019 | capability-only |
| 8 | Smoke test | Doesn't | No agent type checks a deployed URL. | E-021, E-005 | documented-only absence |
| 9 | Orchestrator | Partly | Six hand-offs coordinated; human gates at two; review→fix has no gate or cap; merge gated by label. | E-022, E-020 | capability-only |
| 10 | Extensibility | Partly | Read-only custom agent ran on demand via supported YAML, no fork; no time-based trigger exists. | E-023 | capability-only |

Row 4 note: the allow-list was a hidden requirement, which v2 §4 now forbids. The score is kept as recorded and flagged; it is not re-scored (`METHODOLOGY-v1-VALIDITY-AUDIT.md`, §4).

## Requirements fit — `REQUIREMENTS.md`
No command line day to day: Partly. A person at every hand-off: No as configured. Own repo and PM tool: Yes (GitHub, Trello). Cost visible per run: Yes. Provider switch by config: Yes with a caveat. Two-person operation: Not tested. Setup: measured, 2 h 12 m cold start to webhook-verified.

## Verdict rule and what a fork has to add — `SCORECARD.md`
Rule applied: Partly on rows 4, 9 or 10 rules out Adopt and keeps Fork eligible (D-33). The list of required changes — configurable committer identity, a gate and round cap on review→fix, a gate between stories and coding, review dispatch that waits for CI, backlog feeding without the `auto` label, a deploy/verify stage — is in SCORECARD.md with the finding each traces to.

## Full record in this folder
`SCORECARD.md` (verdict and summary) · `MATRIX.md` (every row with cost, time, human actions, evidence) · `REQUIREMENTS.md` · `FINDINGS.md` (24 numbered findings) · `SECURITY.md` · `LICENSE.md` · `DECISIONS.md` (D-1 … D-37) · `BASELINE.md` · `SETUP-LOG.md` · `evidence/` (52 files, `MANIFEST.md`).

References in these files to `PLAN.md`, `RUBRIC.md` and `FEATURE.md` are to the v1 plan, rubric and task text, at `tools/_shared/PLAN-v1.md`, `tools/_shared/RUBRIC-v1.md` and `tools/_shared/FEATURE-v1.md`. The first attempt that was abandoned and restarted is in `appendix-first-attempt/`.

## What this evaluation cannot say
Single runs, one task class, one repo, one evaluator. Nothing here supports claims about reliability, speed relative to another tool, team operation, or security beyond the recorded checks.
