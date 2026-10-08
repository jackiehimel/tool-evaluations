# E-OH-008 — E2 launch failures and Agent Server model-profile fix

Reconstructed 2026-09-14T02:17Z from the local Agent Server conversation store, the automation database (read-only), and file timestamps. All facts below were verified directly; nothing is copied from session narrative alone.

## Context

The stock `github-issue-to-pr` automation (`2f5f1854-8cef-49d3-9779-a78000e114c8`, created 2026-09-13T23:49:58Z) was enabled for the single approved E2 run after issue #31 (created 2026-09-14T00:34:24Z, label `openhands`) was in place.

## Failed launch attempts

Two automation-spawned conversations errored before any coding work, at zero model cost:

| Attempt | Conversation ID | Created (UTC) | Ended (UTC) | Status | Cost | Model usage bucket |
|---|---|---|---|---|---|---|
| 1 | `f5209e2d-912e-4852-803f-e0a0db215a6c` | 2026-09-14T00:35:12.740709Z | 2026-09-14T00:37:14.004156Z | error | $0.00 | `default` only |
| 2 | `00cb0280-a620-4235-b163-bcc674705a1b` | 2026-09-14T00:38:12.613117Z | 2026-09-14T00:40:13.847556Z | error | $0.00 | `default` only |

Both conversation records remain in `~/.openhands/agent-canvas/dev_conversations/` (machine-local, outside this repo). The `default` usage bucket and zero cost are consistent with the recorded root cause: the stock script's spawned conversations follow the globally active Agent Server LLM settings, so setting the automation's own model field alone did not select the Anthropic model. The root-cause diagnosis itself was made in the executing session; the observable failure signature above corroborates it.

## Fix: named Agent Server profile

- `~/.openhands/profiles/anthropic-sonnet-5.json` was created at 2026-09-14T00:37:09Z (file birth time), between the two failed attempts.
- `~/.openhands/settings.json` (which holds `active_profile`) was last modified at 2026-09-14T00:45Z; it currently shows `active_profile: "anthropic-sonnet-5"` and model `anthropic/claude-sonnet-5`.
- The next automation-spawned conversation (`24f63c60-667b-49a6-848d-f9525573acd5`, created 2026-09-14T00:46:12.808848Z) ran successfully under `anthropic/claude-sonnet-5` and produced PR #32 (E-OH-010 through E-OH-014).

## Finding

The stock automation's per-automation model field did not govern the spawned conversation's model; the globally active Agent Server profile did. This is an environment/setup finding for the requirements row "model provider can be changed by configuration only" and for setup-time accounting. The two failed attempts are launch/configuration failures, not coding-attempt failures, and are preserved here rather than counted against the two-failure rule for the coding step; that classification remains subject to evaluator confirmation at scoring time.
