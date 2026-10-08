# E-OH-003 — E1 backend startup and no-op

Capability demonstration, single setup and single successful no-op. No reliability claim.

## Human gate

The evaluator said "go" at 2026-09-13T19:04-04:00 to start Agent Canvas in backend-only mode and perform one E1 no-op with timing, token and cost capture.

## Cold startup

- Launcher: globally installed `@openhands/agent-canvas@1.18.0`
- Command mode: `agent-canvas --backend-only`
- Start: 2026-09-13T19:04:32-04:00
- Agent Server ready: 2026-09-13T19:04:53-04:00
- Ingress ready: 2026-09-13T19:04:55-04:00
- Cold backend startup through ingress readiness: 23 seconds
- Listening: loopback Agent Server on port 18000, automation on port 18001, ingress on port 8000

The stock 1.18.0 launcher selected OpenHands SDK/Agent Server 1.46.0 and automation 1.11.1 from PyPI. It downloaded CPython 3.12.12 and installed 194 Agent Server packages plus 166 automation packages. This stock runtime selection differs from the Agent Canvas npm package version and is recorded rather than overridden.

Startup warnings:

- VS Code server binary absent; startup continued without VS Code.
- Chromium was detected, but Chromium tool preloading failed; startup continued.
- Telemetry initialized with `enabled=False`.

## Authentication correction

The first conversation request went directly to port 18000 without the launcher's generated `X-Session-API-Key` and returned HTTP 401. No conversation or model call was created. The generated key was then read from `~/.openhands/agent-canvas/api-key.txt` without printing it and supplied through the documented header.

## Successful no-op

- Conversation ID: `dd2994a3-3f8c-4656-b8dc-aa7e22cf8e52`
- Created: 2026-09-13T23:06:14.648541Z
- Finished: 2026-09-13T23:06:15.816352Z
- Conversation runtime: 1.168 seconds
- Recorded model response latency: 1.053 seconds
- Model: `anthropic/claude-sonnet-5`
- Tools supplied: none
- Default tools supplied: none
- Maximum iterations: 1
- Prompt: `This is an E1 no-op capability check. Do not call tools. Reply exactly DONE.`
- Response: `DONE`
- Final execution status: `finished`
- Events: 7

The authenticated conversation creation returned HTTP 201 and immediately started execution. A redundant explicit `POST /run` therefore returned HTTP 409 `Conversation already running`; it did not start a second run.

## Usage

- Prompt tokens: 5,357
- Cache-write tokens: 5,355
- Cache-read tokens: 0
- Completion tokens: 5
- Per-turn tokens reported by Agent Server: 5,362
- Reasoning tokens: 0
- Cost reported by Agent Server: **$0.0134415**

## E1 timing boundary

- Cold setup began with prerequisite/package installation: 2026-09-13T18:16:12-04:00
- Successful no-op finished: 2026-09-13T19:06:15.816352-04:00
- End-to-end wall clock: approximately 50 minutes 4 seconds
- Direct package installation plus cold backend startup plus no-op runtime: approximately 61 seconds
- Remaining wall clock: approximately 49 minutes 3 seconds, consisting of human approval pauses and credential-entry/recovery work

No target repository, GitHub issue, pull request or board item was touched during E1.
