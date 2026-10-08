# E-005 — step 5 extensibility spike (2026-09-02T19:22 to 19:27-04:00, source at pinned commit aee88e20)

Method: one read-only subagent sweep of the Cascade source (five questions, facts only), cross-checked in the main session by re-reading the load-bearing lines. CLI surface read live with `--help` and `definitions export`.

## 1. Definition format — supported, documented
- Custom agents are YAML/JSON validated by `AgentDefinitionSchema` (`src/agents/definitions/schema.ts:286-330`): `identity` (emoji, label, roleHint, initialMessage), `integrations` (required/optional: pm, scm, alerting), `capabilities` (required list, optional list), `triggers` (default `[]`), `strategies`, `hooks` (trailing / finish / lifecycle), `hint`, `prompts` (`systemPrompt` optional, `taskPrompt` required), `requiredContext`.
- Registered without forking: `cascade definitions create --agent-type <t> --file <yaml>` (`src/cli/dashboard/definitions/create.ts`), stored in the `agent_definitions` table; resolution order memory → DB → builtin YAML (`src/agents/definitions/loader.ts`).
- Docs: `docs/architecture/04-agent-system.md:11-140` (schema, example, CLI workflow, custom workflow statuses).

## 2. Triggers — on demand yes, scheduled no
- Event catalog `src/triggers/shared/events.ts` (46 lines): pm:{status-changed, label-added, comment-mention}, scm:{check-suite-success, check-suite-failure, pr-review-submitted, review-requested, pr-opened, pr-comment-mention, pr-merged, pr-ready-to-merge, pr-conflict-detected}, alerting:{issue-alert, metric-alert, issue-lifecycle}, internal:{auto-chain}. Schema regex restricts categories to `pm|scm|alerting|internal` (`schema.ts:16-21`).
- No cron / interval / repeatable trigger anywhere in `src` (the only `setInterval` uses are cleanup jobs and a rate limiter; "schedule" in the trigger docs means BullMQ delayed re-dispatch of an already-matched webhook).
- On demand: `cascade runs trigger --project <id> --agent-type <t> [--work-item-id …]` (`src/cli/dashboard/runs/trigger.ts`) → tRPC `runs.trigger` (`src/api/routers/runs.ts:345-483`) → `triggerManualRun` (`src/triggers/shared/manual-runner.ts:96`). Dashboard "Trigger Run" dialog uses the same route. A custom workflow status mapped to a board list also dispatches a custom agent via pm:status-changed (`docs/architecture/04-agent-system.md:127-149`).

## 3. Read-only enforcement — per definition, real
- Capabilities are an allow-list mapped to tools (`src/agents/capabilities/registry.ts`): `fs:read` → ListDirectory/ReadFile/RipGrep/AstGrep + SDK Read/Glob/Grep; `fs:write` → Write/Edit; `pm:write` → PostComment; `scm:pr` → create-pr. A definition that omits `fs:write` and `scm:pr` never receives those tools.
- Claude Code backend: `allowedTools: sdkTools` derived from capabilities, with `permissionMode: 'bypassPermissions'` (`src/backends/claude-code/index.ts:291,319-322`) — the allow-list is the only restriction; no per-call confirmation. Codex and OpenCode backends derive the same from capabilities.
- Git push, `gh pr create`, `gh pr merge` blocked by a PreToolUse hook (`src/backends/claude-code/hooks.ts:16-30`), default `blockGitPush = true` (`hooks.ts:45`), overridable per definition via `hooks.finish.scm.blockGitPush: false` (only four builtins do).
- No `readOnly` flag or deny-list field; no project-level override found. Builtin `planning.yaml` is an existing read-only example (`fs:read, shell:exec, session:ctrl, pm:read, pm:write, pm:friction`).

## 4. Posting to a card — supported
- `PostComment` gadget (`src/gadgets/pm/PostComment.ts` → `postComment()` → `provider.addComment`; Trello adapter `src/pm/trello/adapter.ts:111-112`), available with `pm:write`.
- Separately, the runtime auto-posts a summary after runs of five builtin types only (`src/triggers/shared/agent-pm-poster.ts:27-35`); custom types must post explicitly.

## 5. Security note for SECURITY.md (step 11)
- Worker agents run with `permissionMode: 'bypassPermissions'`; safety rests on the capability allow-list and the push-blocking hook, not on interactive approval.

## Unknowns
- Per-project capability override: none found, DB schema for agent_configs not read line by line.
- Full tool list for pm/scm/alerting capabilities: only partially read.
