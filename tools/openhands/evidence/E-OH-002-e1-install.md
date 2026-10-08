# E-OH-002 — E1 prerequisite and package installation

Capability demonstration, single setup. No reliability claim.

## Human gate

The evaluator said "go" at 2026-09-13T18:15-04:00 for the Node prerequisite upgrade and pinned Agent Canvas package installation only. The gate did not authorize credential placement, backend startup or an agent run.

## Cold baseline

Before installation:

- Node 22.21.0
- `uv` 0.9.9
- no `agent-canvas` executable
- no `~/.openhands` directory

## Installation record

- Start: 2026-09-13T18:16:12-04:00
- End: 2026-09-13T18:16:49-04:00
- Tool time: 37 seconds
- Node installed through the existing nvm installation: 24.21.0
- npm: 11.19.0
- Command package: `@openhands/agent-canvas@1.18.0`
- Installed packages reported by npm: 609
- Installed binary: the Node 24 nvm prefix's `agent-canvas`
- `agent-canvas --version`: 1.18.0

npm reported that four package install scripts were not on its `allowScripts` list, including Agent Canvas's informational postinstall script. The installation still completed with exit code 0 and the version command succeeded. No backend or agent process was started, no credential was read or written, and no target or evidence repository was changed by the installer.
