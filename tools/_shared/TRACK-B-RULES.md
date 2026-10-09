# Track B — rules shared by every specialist-tool test

These apply to every `tools/<tool>/PROCEDURE.md` that says "Track B". They come from METHODOLOGY.md sections 2, 4, 6, 8, 14.

**Evaluation unit.** Record before the first run: product version or build, install method, the agent CLI and model it drives, the operator's machine type, the target repository and its starting commit. A change to any of these is a new unit.

**Target repository.** The AI Garage web app (Next.js, private). Rules: never push to `main`; never merge; draft PRs only; the tool's branches are deleted after evidence is captured. Credentials stay in the tool's own config, never in this repo.

**Tasks.** From `tools/_shared/tasks/`: the three quick stories and the frozen Changelog feature. Paste verbatim.

**Outcome scale per test.** `Does it` · `Partly` · `Doesn't` (with reason: documented-absence, observed-failure, source-change-required, quality-gap, control-violation) · `Blocked` (external cause, evidenced) · `Not tested` (reason required). Record the initial outcome and, if the operator intervened, the final outcome and the assistance given (none / expected gate action / clarification / product-native recovery / evaluator corrective work / evaluator repair / vendor assistance).

**Stops.** Two failed attempts on a test ends that test. USD cap per task: 5.00, read from the tool's own cost display or the provider dashboard; a cap stop is an outcome, not an invalidity.

**Evidence.** One file per observation, immutable, named `E-<TOOL>-NNN-<slug>.<ext>`, listed in `evidence/MANIFEST.md` with timestamp (ISO-8601, local offset), what it shows, and which test it supports. Screenshots are fine. Raw agent transcripts only when the tool exports them; never paste credentials or tokens.

**Recording.** Every run is screen-recorded. The recording lives in `demos/<tool>/` and is not committed; `evidence/MANIFEST.md` lists its filename and what it covers.

**Provenance label on every capability claim.** stock-native · supported-configuration · supported-extension · composition · evaluator-built · absent.

**What a Track B result may say.** Which lifecycle step the tool improves, the evidence for it, its operating constraints, and whether it belongs alongside a backbone. It gets no end-to-end score and no Adopt/Fork/Build verdict. Without a paired baseline run, a result is a capability observation, not a claim that the tool is better than anything.

**Audit before scoring.** A separate read-only reviewer with access only to the proposed outcomes and `evidence/` marks each test supported / unsupported / evidence-missing before the operator confirms it. Record the audit as an evidence file.
