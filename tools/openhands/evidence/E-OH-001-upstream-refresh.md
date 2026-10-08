# E-OH-001 — decision-critical upstream refresh

Verified 2026-09-13T21:56:59Z by the main session from public documentation, npm registry metadata and pinned public source. No package was installed, no credential was used and no external state was changed.

## Version and installation target

`@openhands/agent-canvas` 1.18.0 is the npm `latest` release, published 2026-09-11T18:39:02Z. Version 1.16.0 remains published with its tarball and metadata intact, so `npx @openhands/agent-canvas@1.16.0` remains an available installation target. Agent Canvas 1.18.0 declares Node `>=24`; 1.16.0 declares Node `>=22.12.0`. The live setup documentation still says Node 22.12 or later, so the package manifest governs the pinned 1.18.0 evaluation prerequisite. The evaluation machine currently has Node 22.21.0, `uv` 0.9.9, no `agent-canvas` executable and no `~/.openhands` directory.

The separate legacy OpenHands CLI remains version 1.16.0. It is not the Agent Canvas package being evaluated. The earlier report conflated the legacy CLI's `openhands --headless` command with Agent Canvas. For E1, Agent Canvas will start with `agent-canvas --backend-only`; the no-op conversation will be submitted to the Agent Server API rather than through the legacy CLI.

## Issue-to-PR automation

`github-issue-to-pr` remains in the current extensions catalog at commit `1bad294d4b9648b14ad335f516edf6f0a6622305`. Its current manifest describes cron polling for labeled GitHub issues, with a configurable schedule defaulting to `*/15 * * * *`. It deduplicates on the matching `labeled` event, starts one OpenHands conversation, then commits, pushes and opens the pull request. The setup skill remains available through `/issue-to-pr:setup`.

## PR reviewer

The current `github-pr-reviewer` script still instructs exactly one `POST /repos/{repo}/pulls/{number}/reviews` with `event: COMMENT`. `APPROVED` and `CHANGES REQUESTED` remain text verdicts in the review body, not GitHub APPROVE or REQUEST_CHANGES events. The relevant source is pinned at extensions commit `1bad294d4b9648b14ad335f516edf6f0a6622305`, lines 821–831 of `skills/github-pr-reviewer/scripts/main.py`.

## Local scheduling, custom automations and events

The current feature matrix says scheduled and polling automations are available on all four backends. It still marks event-driven automations unavailable on Agent Canvas's local backend, available on a reachable VM backend, and available on Cloud and Enterprise. The pre-built-automation page more generally says launcher-created backends include Automation Server and can respond to external events; the backend feature matrix is the more specific availability statement and governs this evaluation. Custom automation manifests still expose cron and event trigger forms. The E4 scheduled custom-agent test therefore remains in scope; a local event-driven lifecycle chain does not.

## Stock lifecycle coverage

The current automation catalog contains 20 entries. No catalog entry is named or described as a stock planner, story splitter, backlog manager, deploy stage, smoke-test agent or lifecycle hand-off orchestrator. Adjacent skills and automations do not supply the prompt→requirements→stories→architecture→code→review→deploy→verify chain with human gates. The prior stage-9 absence remains decision-critical.

## Sources

- [Agent Canvas npm registry metadata](https://registry.npmjs.org/@openhands%2Fagent-canvas)
- [Agent Canvas 1.18.0 release](https://github.com/OpenHands/OpenHands/releases/tag/v1.18.0)
- [Agent Canvas setup](https://docs.openhands.dev/openhands/usage/agent-canvas/setup)
- [Local backend](https://docs.openhands.dev/openhands/usage/agent-canvas/backend-setup/local)
- [Start Conversation API](https://docs.openhands.dev/sdk/guides/agent-server/api-reference/conversations/start-conversation)
- [Enterprise versus open-source feature matrix](https://docs.openhands.dev/enterprise/enterprise-vs-oss)
- [Pre-built automations](https://docs.openhands.dev/openhands/usage/agent-canvas/prebuilt-automations)
- [Event-based automations](https://docs.openhands.dev/openhands/usage/automations/event-automations)
- [Pinned issue-to-PR manifest](https://github.com/OpenHands/extensions/blob/1bad294d4b9648b14ad335f516edf6f0a6622305/automations/catalog/github-issue-to-pr/manifest.json)
- [Pinned issue-to-PR skill](https://github.com/OpenHands/extensions/blob/1bad294d4b9648b14ad335f516edf6f0a6622305/skills/github-issue-to-pr/SKILL.md)
- [Pinned PR reviewer implementation](https://github.com/OpenHands/extensions/blob/1bad294d4b9648b14ad335f516edf6f0a6622305/skills/github-pr-reviewer/scripts/main.py)
- [Pinned custom-automation manifest](https://github.com/OpenHands/extensions/blob/1bad294d4b9648b14ad335f516edf6f0a6622305/automations/catalog/custom-automation/manifest.json)
