## Scope lock
- A "go" authorizes only the step named.
- Every score requires its own `JUDGMENT REQUIRED` gate.
- "Stop at X" is an upper boundary, not authorization to initiate X.
- "Label-only" prohibits score proposals, evidence-to-score audits, and scoring gates.
- If an action could be either metadata work or scoring preparation, stop and ask before creating any artifact.

## Repo rules
- Protocol: `METHODOLOGY.md` (v2). Track B rules: `tools/_shared/TRACK-B-RULES.md`.
- Evidence is immutable; corrections are new IDs. Every score names its evidence.
- Commits in this repo are made by the evaluator under their own name. The tool under test commits to its target repo under a role identity. Run `scripts/precommit-check.sh` before every commit (`SCRUB_LIST` points at the external scrub list).
- Never push to `main` of any target repo; draft PRs only; delete tool branches after evidence is captured.
- No names of people, clients or accounts. No time estimates. No secrets in any file.
