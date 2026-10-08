# E-023 — Step 10 / row 10: custom read-only agent `repo-summary`

Directive section 3 (D-28) as adjusted by D-32: on-demand run only; the "short schedule" half is scored from finding 7 without a cron run. Times UTC.

## Mechanism used (no fork)
- Definition: `E-023-repo-summary-agent.yaml` (final version). Capabilities `fs:read, shell:exec, session:ctrl, pm:read, pm:write`; no `fs:write`, no `scm:*`, no `pm:checklist`; `triggers: []`; `hooks.finish.pm.requiresPMWrite: true`; inline `prompts.systemPrompt` and `prompts.taskPrompt`.
- Registered with `cascade definitions create --agent-type repo-summary --file …` (23:56:41Z); listed by `definitions list` as Built-in = no. Enabled on the project with `cascade agents create --agent-type repo-summary --project-id ai-garage` (23:57:03Z); without that step `runs trigger` refuses ("Add an agent config in Project Settings > Agent Configs").
- Triggered with `cascade runs trigger --project ai-garage --agent-type repo-summary --work-item-id 6a98d0c1… --work-item-title …`.
- Cascade source checkout untouched (`git status --porcelain` empty throughout).

## Attempt 1 — boot failure (23:57:05Z → 23:59:06Z, run d23df9df, $0)
`BootFailureError: plan resolution failed: ENOENT … /app/dist/agents/prompts/templates/repo-summary.eta`. The worker loads the system prompt from a template file named after the agent type inside its image unless the definition carries `prompts.systemPrompt` (`src/agents/shared/modelResolution.ts:83-89` → `src/agents/prompts/index.ts:112-122`). The docs mark `systemPrompt` optional and their custom-agent example omits it (`docs/architecture/04-agent-system.md:11-81`). Finding 23. Change: `prompts.systemPrompt` added, `definitions import --update` at 00:00:49Z.

## Attempt 2 — success (00:00:52Z → 00:03:27Z, run 3e0ce499, 154.7 s, $0.24, success true)
| Event | Time |
|---|---|
| Worker start; TypeScript cache warm (120.5 s of the 154.7 s) | 00:00:53Z → 00:02:53Z |
| Claude Code session initialized, **tools: Bash, Glob, Grep, Read** (no Write, no Edit, no NotebookEdit) | 00:02:54Z |
| Commands run (all read-only): `pwd && ls -la`; `cat README.md \| head -60; cat package.json; ls registry; find registry -type f \| wc -l`; `ls registry/agents; find … \| wc -l; ls app; git log --oneline`; a heredoc to `/tmp/summary.md` | 00:02:56Z → 00:03:05Z |
| `cascade-tools pm post-comment --workItemId 6a98d0c1… --text-file /tmp/summary.md` → **summary comment on the card** (12 lines: purpose, framework, top-level dirs, the four check commands, 35 registry entries) | 00:03:07Z |
| `cascade-tools session finish` → SDK turn completed, 7 turns, $0.18 | 00:03:13Z |
| Cascade completion check: "Agent completed but no PM write (checklist creation) was recorded" → continuation turn forced | 00:03:13Z |
| Agent runs `cascade-tools pm add-checklist … "Repo Summary Plan"` (5 items describing what it did) to satisfy the check; second `session finish`; 3 turns, $0.05 | 00:03:19Z → 00:03:27Z |

## Permission check
- SDK tool allow-list at session init: Bash, Glob, Grep, Read. No file-writing tool was available (the `fs:write` capability maps to Write/Edit, `src/agents/capabilities/registry.ts`).
- PM writes went through the in-worker `cascade-tools` CLI over Bash; `pm post-comment` and `pm add-checklist` both belong to the `pm:write` capability (`registry.ts:26-34`), so the checklist was inside the granted capabilities, not a bypass. The `gh` binary is shimmed to print "gh is unavailable in CASCADE agent runs" (`src/backends/nativeToolRuntime.ts:19`).
- Git push block: `blockGitPush` defaults to true and the definition does not override it (`src/backends/claude-code/hooks.ts:16-45`). The run attempted no push, so the block was not exercised; its presence is by source, not by observation.
- No file in the workspace was modified by the agent's commands (only `/tmp/summary.md` outside the repo).

## Schedule half
Not run (D-32). The event catalog has no time-based trigger (finding 7, E-005); a schedule would be host cron calling `runs trigger`, outside the tool.

## Cost
Two runs: $0 (boot failure) + $0.24. Setup: 3 CLI commands plus one definition update. Evaluator corrective work on the definition: one field added after the boot failure (about 10 minutes, source reading included).

## Files
`E-023-repo-summary-agent.yaml`, `E-023-repo-summary-run-log.json` (full run log, scrubbed).
