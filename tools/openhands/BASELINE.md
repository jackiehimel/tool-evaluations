# OpenHands baseline

Captured before the E2 agent run. This is a capability demonstration, single run.

## Target

- Repository: private target repository named in the approved procedure
- Default branch: `main`
- Live default-branch SHA recorded by the completed setup snapshot at 2026-09-13T19:50:30-04:00: `0288076f2f7ec030b113ffc46d374d5f3eb9116c`
- Local checkout was not updated or modified during setup

## Stock product

- Agent Canvas npm package: `@openhands/agent-canvas@1.18.0`
- Node: `24.21.0`
- npm: `11.19.0`
- Agent Server / OpenHands SDK: `1.46.0`
- Automation server: `1.11.1`
- Extensions source: `1bad294d4b9648b14ad335f516edf6f0a6622305`
- Model: `anthropic/claude-sonnet-5`
- Mode: backend-only
- Agent Server: loopback port 18000
- Automation server: loopback port 18001
- Ingress: port 8000

## E2 automation

- Stock template: `github-issue-to-pr` version `1.0.0`
- Automation ID: `2f5f1854-8cef-49d3-9779-a78000e114c8`
- Trigger: cron, `*/1 * * * *`, UTC
- Trigger label: `openhands`
- Branch prefix: `openhands/issue`
- Pull requests: draft
- Maximum new work items per poll: 1
- Entrypoint: `python3 main.py`
- Timeout: 900 seconds
- Enabled automations: none
- Configured automation state: disabled
- Last triggered: never
- Run count: 0

## Configuration integrity

- Stock script SHA-256: `75d15075b678c87f48d42efb78fd9e6705e0d557fdf6d689a2a6175ab89f1ce3`
- Non-secret config SHA-256: `4bd906d87eb14772449a5c8242f3772d963ff2d15dcf9adcdacfd789687e0f73`
- Bundle SHA-256: `52b6ea36f28398a50aa282fac4922321f5319425ed0fb5fea28073a39a32fa39`
- Bundle size: 15,603 bytes
- The stock source declares commit identity `OpenHands <openhands@all-hands.dev>`; observed runtime identity remains to be recorded if E2 creates a commit.

## Credentials

- Model credential: present in the evaluator-owned environment file; value not copied here
- Local session key: present; value not copied here
- GitHub secret: `GITHUB_PERSONAL_ACCESS_TOKEN`, present after the E-OH-007 corrected reseeding from the existing Cascade implementer credential
- OpenHands secret store permissions: mode 600
- Agent secret allow-list: `GITHUB_PERSONAL_ACCESS_TOKEN` only

The GitHub credential authenticated successfully and could read the private target, issues and labels. The repository response reported push access. E-OH-006 retracts the later 19-repository scope alarm: `GET /user/repos` reflected account visibility, while the preserved Cascade record established that the replacement fine-grained token was selected only for the target. The configured `openhands` label did not exist at capture time and has not been created.
