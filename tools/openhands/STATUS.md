# OpenHands (Agent Canvas) — status

**No scores. No verdict.** Evidence was collected Sep 13–14, 2026 under protocol v1 and is complete for the steps that ran. No row has passed its scoring gate. One planned test was never run.

Evaluation unit: Agent Canvas 1.18.0 (`@openhands/agent-canvas`), MIT, local backend, stock automations (`github-issue-to-pr`, reviewer), Claude Code engine, one evaluator, same target repo and frozen Changelog task as Cascade. Procedure: `PROCEDURE.md` (amended 2026-09-13).

## What ran

| Step | What happened | Evidence |
|---|---|---|
| E1 install | Agent Canvas started backend-only; no-op conversation through the Agent Server API. | E-OH-002, E-OH-003 |
| E2 credentials | Token-scope blocker found and corrected; two launch failures before the working profile. | E-OH-004 … 008 |
| E2 coding | One stock issue-to-PR run on the exact frozen prompt → draft PR #32 on a feature branch: route, feed logic, nav entry, tests. Local suite and CI passed. | E-OH-010 … 013, E-OH-017 |
| E2b review | Stock reviewer approved the clean head. | E-OH-015, E-OH-016 |
| Control 1 | Evaluator injected a failing test → CI red → no OpenHands component reported it. Reverted. | E-OH-019 … 024 |
| Control 2 | Evaluator injected a `.slice(1)` defect → reviewer identified it precisely. Reverted. (That branch already failed four tests, so this is not comparable to Cascade's control, where the suite stayed green.) | E-OH-025 … 032 |
| Contamination | A Cascade webhook reviewed PR #32; excluded from OpenHands credit. | E-OH-009, D-OH-25 |
| E4 extensibility | **Not run.** Planned repository-summary agent, on demand and scheduled. | — |

## What the evidence shows per stage (no score entered)
BRD, Stories, Architecture, Smoke test: documented absence of a stock stage. Coding: one observed run, PR opened, checks passed. Checks: CI passed; failed-CI not reported natively. Review: capability observed on one planted defect. Deploy: no native stage. Orchestrator: scheduled issue-to-PR and review ran; no requirements-to-verification chain on the local backend. Extensibility: not tested.

D-OH-5 pre-registers Build as the consequence of stage 9's documented absence. That is a rule written before the run, not a confirmed verdict.

## Why there are no scores
Evidence collection ended before the scoring gates were held. Stage 1 has a completed evidence-to-score audit on file (E-OH-033, proposed `Not tested`, result supported); the gate itself has not been held. Scores are entered only at a gate, under the protocol named below.

## To finish
Decide: score rows 1–9 under the frozen v1 procedure this evidence was collected under (then label under v2, as Cascade was), or reopen under v2 including the missing E4 run. Then one gate per row with the audit step from `METHODOLOGY.md` §14.

## Files
`PROCEDURE.md` · `BASELINE.md` · `DECISIONS.md` (D-OH-1 …) · `SETUP-LOG.md` · `evidence/` (35 files, `MANIFEST.md`).
