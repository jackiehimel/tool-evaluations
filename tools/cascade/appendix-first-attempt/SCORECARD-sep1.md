# SCORECARD — Cascade (mongrel-intelligence/cascade @ aee88e20, 2026-08-25)

Same rubric for Cascade, OpenHands, claude-code-action, pullfrog. Fill every row; "n/a" is an answer, blank is not.
This scorecard evaluates the tool only. Time lost to our own credential and board-prep mistakes is excluded; the full timeline is in SETUP-LOG.md.

## Setup
| Item | Value |
|---|---|
| Setup time attributable to the tool | About **35 minutes** of hands-on tool time: `setup.sh` built and started everything in 3 minutes on a Mac (Docker Desktop, four containers, a 6.6 GB worker image built locally); the rest was project configuration, credentials entry, webhook registration and verification. |
| Hosting model | Self-hosted Docker Compose: postgres 16, redis 7, dashboard (:3001), router (:3000, mounts the host Docker socket), plus a worker image spawned per job. Needs a public URL for webhooks; ngrok on a laptop. |
| PM sources supported; the one used | Trello, Jira, Linear (GitHub as SCM; Sentry for alerting). Used: **Trello**. |
| Documentation gaps | Four things needed reading source, not docs. (1) **Webhook registration from a self-hosted install**: the dashboard's "Create GitHub Webhook" and Trello wizard buttons compute the callback from the browser origin, so they register `http://localhost:3001`, which GitHub and Trello cannot reach. The CLI `webhooks create --callback-url` works and is not in the getting-started guide. (2) **Enabling an agent does not enable its triggers**: the implementation agent's "card moved to To Do" trigger ships `defaultEnabled: false`. The dashboard's Enable button turns both on; the CLI `agents create` does not. (3) **Default model and default engine are incompatible**: a new project defaults to engine `claude-code` and model `openrouter:google/gemini-3-flash-preview`, and the engine rejects any non-Claude model. The getting-started guide says the default engine needs only an Anthropic key and never says to set a model. A project created by the book fails on its first run. The error message names the fix. (4) **PAT permissions**: Cascade registers the GitHub webhook with the implementer token, so the fine-grained PAT needs Webhooks read/write in addition to Contents, Pull requests, Issues and Metadata. Not documented. |
| Blockers hit and how resolved | (a) Webhook callback pointed at localhost → registered via CLI with the tunnel URL. (b) First run skipped: trigger off by default → `projects trigger-set ai-garage -a implementation -e pm:status-changed --enable`. (c) Second run failed in 1 s: model/engine mismatch → `projects update ai-garage --model claude-sonnet-5`. (d) Vercel blocked the preview because Cascade hard-codes the commit author as `Cascade Bot <bot@cascade.dev>` and Vercel (Hobby) builds only commits authored by the account owner → for this eval, an empty commit under the owner's identity, then a two-line source patch so later runs commit as the owner. The patch is being reverted for the clean re-run; previews will be recorded as blocked by Vercel policy. |

## Stories (one row each)
| Story | Card→PR | Diff scope matches AC | CI green | Preview OK | Reviewer output | Cost | Manual touches |
|---|---|---|---|---|---|---|---|
| 1 title | **65 s** (card into To Do 02:36:00Z, PR #23 opened 02:37:05Z). Preceded by one skipped run (trigger off by default) and one 1-second failure (model/engine mismatch), both configuration defaults, both fixed with one command each. | **Yes.** `app/layout.tsx` only, +1/−1, the `title` string only. Branch `fix/page-title` (prefix `fix/` although the project setting says `feature/`). | **Yes.** Actions `verify` and Vercel both passed; reproduced locally in a clean worktree: lint, typecheck, 79 tests, build. | **No, on stock Cascade.** Vercel blocked the deployment because the commit author `bot@cascade.dev` is not the Vercel account owner. Built only after an empty commit under the owner's identity. Recorded as a Vercel policy limitation, not a Cascade malfunction. | n/a — review agent not enabled; reviewer slot left empty by design. Router logs `reviewer_token not found` on every GitHub event, harmless. | **$0.51**, claude-sonnet-5, engine claude-code. Per-call token breakdown in the dashboard's LLM Calls tab (the CLI `runs llm-calls` crashed: `rows.reduce is not a function`). | **2 before the PR** (enable trigger, set model). **1 after** (empty commit for Vercel). |
| 2 footer | **88 s** (card into To Do 05:43:31Z, PR #24 opened 05:44:59Z). First try, no retries. | **Yes.** `components/site-footer.tsx` (new, 19 lines), `app/layout.tsx` (+2), `app/globals.css` (+43). Design tokens only, no raw colors, no comments, imports at top, semantic `<footer>`/`<nav aria-label>`, follows the existing nav pattern. | **Yes.** Reproduced locally: lint, typecheck, 79 tests, build. | **Yes**, but only because the run used the patched author. On stock Cascade it would be blocked as in story 1. | n/a | **$0.73**, 1 m 35 s. | **0.** The agent ran the full gate itself and listed it in the PR body; all four checks reproduce. |
| 3 route titles | not run | | | | | | |

## PR quality (as a code reviewer would write it)
**PR #23 `fix(layout): update AI Garage page title`** (https://github.com/<owner>/ai-garage-web/pull/23)
- Correctness: exactly the requested change, nothing else. The agent found other occurrences of the old title (README, `lib/garage-content.ts`), reasoned they are not the tab title and left them alone. Right call under "Do not change anything else".
- AGENTS.md conventions: nothing to violate in a one-line change. It did not run the full pre-commit gate: the PR body claims typecheck, ESLint on the one file and `npm test`, not whole-tree lint or build. Both pass, but the claim is narrower than the repo's rule.
- Commit: `fix(layout): update AI Garage page title`, conventional-commit style, accurate. Author `Cascade Bot <bot@cascade.dev>` (hard-coded).
- PR description: good. Summary, Details with the Trello card link, Test plan with checkboxes. Does not use the repo's `.github/pull_request_template.md` headings, though it covers the same ground.
- Would request changes on: nothing blocking. Nits: use the repo PR template; run and cite the full gate; follow the project's branch prefix.

**PR #24 `feat(layout): add site footer with submit and contact links`** (https://github.com/<owner>/ai-garage-web/pull/24)
- Correctness: does what the ticket asks on every page, two links with the exact labels and hrefs, the exact copy. Responsive padding mirrors the nav's 720 px breakpoint.
- AGENTS.md conventions: followed. Tokens only, no comments, `@/` alias, Next `Link`, named export like `PortalNav`. Ran the full gate and said so.
- Commit: `feat(layout): …`, accurate; branch `feature/site-footer` follows the project prefix.
- PR description: Summary, card link, four-item test plan. Still not the repo template headings.
- Would request changes on: nothing blocking. Nits: confirm the footer doesn't overlap pages that set their own min-height; `14.5px`/`13.5px` are new magic numbers (consistent with the nav's literals); no test added (none exists for the nav either).

## Reliability
- Once configured, every run behaved: every webhook event delivered, every job dispatched, every worker exited clean (status 0, not OOM, ~310 MiB of 4 GiB at peak). No hangs, no retries, no crashes of the four core services.
- Webhook delivery is fast: GitHub ping answered in 0.13 s; Trello actions reached the router within ~300 ms; 10 s coalescing window; worker container up 10 s after the card move.
- Feedback on failure is good: the model mismatch produced a clear log line, a card comment naming the fix, and an `error` label on the card. The skipped-trigger case produced only a log line; nothing on the card.
- **WIP gate:** `maxInFlightItems` defaults to 1, counted over To Do + Doing + In Review. A finished card left in In Review silently blocks the next run: the router logs `pipeline-at-capacity: skipping` and the card gets no label or comment. Reasonable rule, no user-visible feedback.
- Commit author is hard-coded (`src/utils/repo.ts:58-59`); not configurable without a source patch. This is what collides with Vercel's author policy.
- Log quality: router logs are structured and readable. `webhooklogs` shows per-delivery decisions, but "Event unparseable or not processable" covers both "no project for this board" and "not a trigger", which costs time when debugging.
- CLI rough edges: `runs show/logs` reject the short ids that `runs list` prints; `--json` output shapes vary per command; `runs llm-calls` crashes.

## Security observations
- Secrets at rest: project credentials in Postgres, AES-256-GCM with a master key from `.env`. Dashboard shows them masked; the CLI never echoes them.
- Secrets in workers: passed as container environment variables, so the GitHub PAT and Anthropic key are readable by anything inside the agent container, including the agent. Git auth is the token embedded in the HTTPS clone URL.
- Token scopes required: fine-grained PAT on one repo with Contents RW, Pull requests RW, Issues RW, Metadata R, Webhooks RW (for self-registration; otherwise add the hook by hand). Trello: API key + a user token with read,write; Cascade acts on Trello as that user. Anthropic: an API key or Claude Max token.
- Can it touch `main`: no code path pushes to the base branch. The only merge path is the `pr-ready-to-merge` trigger, double-gated: the SCM integration's "PR Ready to Merge" toggle (default off, verified off) AND a Trello label mapped to `auto` (verified absent). 
- Ingress: GitHub deliveries are unsigned unless `GITHUB_WEBHOOK_SECRET` is set. Trello webhooks are signature-verified.
- The router mounts the host Docker socket, which is root-equivalent on the host. Fine on a laptop; a real question for a shared deployment.

## License
SPDX: **MIT**. Copyright (c) 2026 **Zbigniew Sobiecki and CASCADE Contributors**. MIT permits use, copying, modification, redistribution, sublicensing and sale, including rebranding, provided the copyright and permission notice are retained. No patent grant; the "CASCADE" name and logo are not covered. For a rebranded fork: confirm notice retention and check third-party assets in `web/` for different terms.

## Would this survive a customer demo?
The run itself is demo-grade: drag a card, a worker appears in ten seconds, progress and errors are narrated on the card, a correct PR opens in about a minute for under a dollar, and main is never touched. What would sink an unrehearsed demo is first-run configuration: out of the box a new project has a trigger that is off, a model its engine refuses, and webhook buttons that point at localhost on a self-hosted install, and the docs cover none of the three. A rehearsed setup with trigger, model and webhooks already in place would demo fine. Two things a customer would notice: commits are authored by a made-up bot address while the PR is opened by whichever account owns the PAT, which confuses Vercel and would confuse people; and the review agent needs a second GitHub identity because GitHub will not let an account approve its own PR. Both point to a dedicated machine user per project.
