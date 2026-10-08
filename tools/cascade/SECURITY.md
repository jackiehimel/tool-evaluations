# Security notes — Cascade (stock aee88e20, one page)

What was observed during the evaluation, with source lines where the behaviour is by design. No new tests were run for this page (D-32). Items marked "counsel" or "operator" are for the reader to act on, not findings against the tool.

## Tokens held and their scopes
| Credential | Scope as used | Where it lives | Notes |
|---|---|---|---|
| Implementer GitHub token | Fine-grained PAT on the target repo: contents and pull requests read/write, Actions read (added 2026-09-02T22:50 EDT, finding 18) | `.env`, Cascade credential store, worker env | Commits are still authored `Cascade Bot <bot@cascade.dev>` regardless of the token (finding 5). |
| Reviewer GitHub token | Classic PAT, scope `repo`, on a plain second account (`adlc-reviewer-bot`) | `.env`, credential store, review-worker env | Separate identity and separate worker process per review (E-014). |
| Trello key and token | The evaluator's own Trello identity, no expiry (D-13) | Credential store | Cascade has no Trello identity of its own (finding 4): every bot action is indistinguishable from the token owner's. |
| Anthropic API key | Full key | `.env`, worker env | Model `claude-sonnet-5` through the Claude Code engine. |
| `CREDENTIAL_MASTER_KEY` | Encrypts the credential store (`src/db/crypto.ts:10`) | `.env`, router only | Denylisted from worker env (`src/backends/shared/envFilter.ts:24-37`). |
| Postgres password | Local containers only | `.env` | |

## Where secrets are readable
- Host: `.env` in plain text (12 keys, values never printed by this evaluation).
- Router: the `project_credentials` table, encrypted at rest, decrypted in memory on demand (`credentialsRepository.resolveProjectCredential`); this evaluation used exactly that path for its board reads, so anyone with `docker exec` on the router can read every credential.
- Worker: an allow-listed environment (`envFilter.ts`); the LLM key and the persona's GitHub token reach the container, and the tokenised clone URL is written into the workspace's git config (`src/utils/repo.ts`, D-6), so an agent with Bash can print its own GitHub token. `DATABASE_URL`, `REDIS_URL` and the master key do not reach workers.

## What an agent can execute
- Claude Code runs with `permissionMode: 'bypassPermissions'`; the only restriction is the tool allow-list derived from the definition's capabilities (`src/backends/claude-code/index.ts:319-322`, finding 11). With `shell:exec` that includes unrestricted Bash inside the worker container (E-023 shows `find`, `cat`, heredocs; implementation runs show `npm ci`, `npm run build`).
- Guard-rails: `git push`, `gh pr create`, `gh pr merge` are blocked by a PreToolUse hook (`src/backends/claude-code/hooks.ts:16-45`, default on); `gh` itself is shimmed to an error message (`src/backends/nativeToolRuntime.ts:19`); PM and SCM writes go through the `cascade-tools` CLI, whose subcommands follow the granted capabilities (`pm:write` = post-comment and add-checklist, E-023).
- Workers are one container per run from a 6.6 GB image (Claude Code 2.1.185 pinned). The router holds `/var/run/docker.sock` (`docker-compose.yml:91`) to spawn them, so a compromise of the router is a compromise of the Docker host (operator: isolate the host).
- Merge is gated by the `auto` label on the card, not by a person (finding 16); with the label present the tool merges its own approved PRs.

## Git identity and hosting
Every commit is `Cascade Bot <bot@cascade.dev>`, hard-coded, unsigned, not linked to any account (finding 5). Consequence observed: Vercel refuses preview deployments for those commits ("GitHub couldn't verify an account for commit", E-017). Operator: a per-project committer identity needs a source patch, or a hosting-side allowance for unverified authors.

## Data sent to third parties
Repository contents the agent reads, card text, PR diffs, reviews and comments are sent to Anthropic through the Claude Code engine (prompt caching on: 1.64 M of 1.77 M input tokens were cache reads on one run, E-016). Sentry is used only when `SENTRY_DSN` is set (`src/instrument.ts:3-5`; unset in this install). No other telemetry endpoint was found in `src/` (grep for sentry, posthog, telemetry). GitHub and Trello traffic is the integration itself.

## Branch protection observed
None. The target repo is private on a plan where branch protection and rulesets are unavailable (API: "Upgrade to GitHub Pro", 403), and force-push is allowed at the repo level. The never-merge and never-push-to-main rules held throughout only because of the tool's push hook, the absent `auto` label and the evaluation's own discipline. Operator: on a customer repo, require branch protection on main before enabling the merge label.

## Webhooks
One GitHub hook and one Trello hook point at a public tunnel (E-004). The dashboard cannot register hooks behind a tunnel (finding 10), so they were created by CLI.
