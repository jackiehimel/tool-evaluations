# tool-evaluations

Evaluation records for AI development tooling: coding-agent orchestrators, cockpits, QA agents and related tools. One folder per tool under `tools/`. Every claim in a result points at an evidence file.

## How to read this repo

- `METHODOLOGY.md` — the evaluation protocol (v2). `METHODOLOGY-v1.md` is what Cascade and OpenHands ran under; `METHODOLOGY-v1-VALIDITY-AUDIT.md` is the review of its flaws that led to v2.
- `comparison/COMPARABILITY.md` — Cascade vs OpenHands, stage by stage, with what each comparison can and cannot support. Two tracks: Track A for tools that could run the whole development lifecycle, scored on ten stages; Track B for specialist tools, tested on a few focused differentiators.
- `tools/<tool>/PROCEDURE.md` — what was tested and how, written before the run.
- `tools/<tool>/evidence/` — immutable records: outputs, diffs, logs, screenshots. `MANIFEST.md` lists them.
- `tools/<tool>/RESULTS.md` — the outcome per registered test, with evidence IDs, assistance given, cost, and what the evidence does and does not support.
- `tools/_shared/tasks/` — the frozen tasks every tool gets, so results are comparable.

## Status

| Tool | Track | Status |
|---|---|---|
| Cascade | A | **Evaluated** (Sep 2026, v1). Verdict Fork. `tools/cascade/RESULTS.md`. |
| OpenHands | A | Evidence collected (Sep 2026, v1). Not scored; one test not run. `tools/openhands/STATUS.md`. |
| Cezar | B | Procedure registered. Testing. |
| Vercel Eve (Foreman template) | B | Procedure registered. Testing. |
| Cursor Automations | B | Procedure registered. Testing. |

## Rules that apply to everything here

- Evidence is collected first, then scored. Scores are never changed after the fact; a correction is a new evidence ID.
- No time estimates. Measured time only.
- No client names, no account names, no credentials. Role identities in commits.
- A test that was not run is `Not tested`, never `Does it` or `Doesn't`.
- `scripts/precommit-check.sh` runs the scrub-list and secret checks before every commit.
