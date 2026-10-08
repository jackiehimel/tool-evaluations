# E-OH-004 — E2 credential validation and disabled automation configuration

Capability demonstration, single configuration. No agent run and no score.

## Human gate

The evaluator said "go" at 2026-09-13T19:46:15-04:00 for GitHub credential validation and seeding plus configuration of the stock `github-issue-to-pr` automation only. The gate did not authorize an issue, label creation, automation run, branch, pull request, score or commit.

Waiting-for-human time from the read-only reconciliation report at 2026-09-13T19:14:29-04:00 to the recorded gate was 31 minutes 46 seconds.

## Credential validation

- Exactly one nonempty implementer-token assignment was found in the evaluator-owned credential source.
- Its structure matched a recognized GitHub personal-access-token prefix.
- `GET /user`: HTTP 200; an authenticated identity was present but is not copied into evidence.
- `GET` target repository: HTTP 200; the repository was private and the response reported pull and push access.
- `GET` labels: HTTP 200.
- `GET` issues: HTTP 200.
- Initial authenticated validation request time: 1.071 seconds.
- Live default-branch lookup: HTTP 200 in 0.767 seconds.
- Default branch: `main`.
- Live default-branch SHA: `0288076f2f7ec030b113ffc46d374d5f3eb9116c`.
- `GET` configured trigger label: HTTP 404. The label did not exist and was not created.

The stock automation documents fine-grained Contents, Issues, Pull requests and Workflows read/write permissions. Read-only validation proved authentication, repository visibility and reported push access. It did not mutate the repository to prove each individual write grant.

The implementer token was seeded under the stock secret name `GITHUB_PERSONAL_ACCESS_TOKEN`. The OpenHands secret store remained mode 600. No credential value was printed, logged or copied into this repository.

## Stock bundle

- Extensions commit: `1bad294d4b9648b14ad335f516edf6f0a6622305`
- Template: `github-issue-to-pr` version `1.0.0`
- Script used unchanged from the pinned source
- Stock script SHA-256: `75d15075b678c87f48d42efb78fd9e6705e0d557fdf6d689a2a6175ab89f1ce3`
- Non-secret config SHA-256: `4bd906d87eb14772449a5c8242f3772d963ff2d15dcf9adcdacfd789687e0f73`
- Bundle SHA-256: `52b6ea36f28398a50aa282fac4922321f5319425ed0fb5fea28073a39a32fa39`
- Bundle size: 15,603 bytes
- Upload ID: `0859991c-5f75-4a08-b827-0b5ac896d84d`
- Draft validation: valid, zero errors

Non-secret configuration:

- one target repository
- label `openhands`
- branch prefix `openhands/issue`
- draft pull requests
- one new work item maximum per poll
- `GITHUB_PERSONAL_ACCESS_TOKEN` as the only agent secret
- local ingress at port 8000

## No-run configuration sequence

The raw automation creation endpoint does not accept an initial `enabled` field. To avoid a one-minute cron race:

1. The automation was created with the non-imminent schedule `0 0 1 1 *`.
2. The returned automation was immediately disabled.
3. While disabled, its final schedule was changed to `*/1 * * * *`, UTC.

Final state at 2026-09-13T19:50:30-04:00:

- Automation ID: `2f5f1854-8cef-49d3-9779-a78000e114c8`
- Enabled: false
- Schedule: `*/1 * * * *`
- Timezone: UTC
- Entrypoint: `python3 main.py`
- Timeout: 900 seconds
- Last triggered: null
- Run count: 0
- Run status counts: empty
- Agent Server, automation server and ingress health: `{"status":"ok"}`

Configuration wall clock after the gate: 4 minutes 15 seconds. No model call occurred, so model tokens and model cost were zero. No issue, label, branch, pull request, target checkout change, agent run or score occurred.
