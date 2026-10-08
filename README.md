# tool-evaluations

Evaluation records for AI development tooling: coding-agent orchestrators, cockpits, QA agents and related tools. One folder per tool under `tools/`. Every claim in a result points at an evidence file.

## How to read this repo

- `METHODOLOGY.md` — the evaluation protocol (v2). `METHODOLOGY-v1.md` is what Cascade and OpenHands ran under; `METHODOLOGY-v1-VALIDITY-AUDIT.md` is the review of its flaws that led to v2.
- `comparison/COMPARABILITY.md` — Cascade vs OpenHands, stage by stage, with what each comparison can and cannot support. Two tracks: Track A for tools that could run the whole development lifecycle, scored on ten stages; Track B for specialist tools, tested on a few focused differentiators.
- `tools/<tool>/PROCEDURE.md` — what was tested and how, written before the run.
- `tools/<tool>/evidence/` — immutable records: outputs, diffs, logs, screenshots. `MANIFEST.md` lists them.
- `tools/<tool>/RESULTS.md` — the outcome per registered test, with evidence IDs, assistance given, cost, and what the evidence does and does not support.
- `tools/_shared/tasks/` — the frozen tasks every tool gets, so results are comparable.

## How an evaluation runs

1. **Classify the tool.** Track A if it could run the whole development lifecycle; Track B if it is a specialist. Rules: `METHODOLOGY.md` §3 and `tools/_shared/TRACK-B-RULES.md`.
2. **Register the procedure before running anything.** `tools/<tool>/PROCEDURE.md` lists each test, the exact command, what counts as pass, and the evidence file it will produce. The procedure is frozen once the run starts.
3. **Run the tests on the frozen tasks** in `tools/_shared/tasks/`. Each test produces an evidence file in `tools/<tool>/evidence/`, named `E-<TOOL>-NNN-<slug>` and listed in `MANIFEST.md`. Evidence is never edited afterwards; a correction is a new file.
4. **Audit before scoring.** A separate reviewer who did not run the tests reads only the proposed scores and the evidence folder and marks each row `supported`, `unsupported`, or `evidence-missing`. The audit result is itself an evidence file (`METHODOLOGY.md` §14).
5. **Score at a gate.** A person enters scores at a `JUDGMENT REQUIRED` gate, after the audit. Track A gets the ten-stage matrix and a suitability verdict (§13). Track B gets an outcome per test (`Does it` / `Partly` / `Doesn't` / `Blocked` / `Not tested`) and no verdict.
6. **Write `RESULTS.md` from the evidence.** Every claim carries an evidence ID. Cost and measured time are reported; assistance given to the tool is listed. What the evidence does not support is stated.

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
- No client names, no account names, no credentials. The tool under test commits to its target repo under a role identity, never as a person.
- A test that was not run is `Not tested`, never `Does it` or `Doesn't`.
- `scripts/precommit-check.sh` runs the scrub-list and secret checks before every commit.
