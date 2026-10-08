# E-OH-005 — E2 GitHub token scope blocker and rollback

Credential-scope correction to E-OH-004. No agent run and no score.

## Independent checks

Two read-only research checks completed by 2026-09-13T19:52:22-04:00 and were verified by the main session against the pinned source and live local API:

- The stock direct custom-tarball creation endpoint creates automations enabled and does not accept an initial `enabled` field.
- Creation itself does not dispatch, but an enabled automation can run at its next cron tick.
- The E-OH-004 sequence—create on a non-imminent schedule, disable, then set the final schedule while disabled—was safe.
- The minimum fine-grained GitHub repository permissions are Metadata read, Contents read/write, Issues read/write, Pull requests read/write and Workflows read/write.
- No account-level permissions are required.
- The token should be selected for only the target repository.

## Main-session scope verification

An authenticated read-only `GET /user/repos` check returned HTTP 200:

- visible repositories: 19
- target repository present: yes
- target repository only: no
- unrelated repositories visible: 18

The token therefore exceeded the required repository boundary. No repository names other than the approved target are copied into evidence.

## Rollback

The main session removed the seeded `GITHUB_PERSONAL_ACCESS_TOKEN` value from the OpenHands secret store. It did not modify or revoke the evaluator's source token.

Verified at 2026-09-13T19:55:11-04:00:

- GitHub secret present in OpenHands: false
- OpenHands secret-store mode: 600
- E2 automation enabled: false
- E2 automation last triggered: null
- E2 automation run count: 0
- E2 automation schedule retained: `*/1 * * * *`
- Local target checkout remained unchanged at `3b0fab7f5c1a371facec0e4a81b451e762c7595f`

E2 is blocked before label or issue creation. The evaluator must restrict the existing fine-grained token to only the target repository or provide a replacement with that repository selection and the required permissions, then authorize revalidation and reseeding. No issue, label, branch, pull request, agent run, score, commit or teardown occurred.
