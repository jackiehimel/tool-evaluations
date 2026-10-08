# E-OH-006 — correction to E2 token-scope finding

Correction to E-OH-005. No credential use, agent run or score.

At 2026-09-13T20:21-04:00 the evaluator stated that the GitHub credential had already been prepared and validated for the Cascade evaluation and instructed the OpenHands evaluation to reuse it.

The main session re-read the preserved Cascade credential record and obtained an independent read-only check. Both showed that E-OH-005 used the wrong scope test:

- `GET /user/repos` lists repositories visible to the authenticated user. Its result is not the fine-grained token's selected-repository list.
- The Cascade record had already identified and corrected this exact mistake.
- The replacement implementer token returned HTTP 200 for the private target repository and selected protected endpoints.
- Unrelated public repositories visible through `GET /user/repos` returned HTTP 403 on protected endpoints.
- The unrelated private legacy repository returned HTTP 404.
- The evaluator verified the replacement token's target-only selection on GitHub's token settings page.

Therefore the E-OH-005 conclusion that the token covered 19 repositories is retracted. The 19-repository response described account visibility, not token grants. The existing Cascade implementer token is the approved credential source for OpenHands E2; no replacement or repository-selection change is required.

The seeded copy had already been removed before this correction. The OpenHands automation remains disabled and has zero runs. Reseeding the existing credential remains a credential action and waits for the next explicit gate.
