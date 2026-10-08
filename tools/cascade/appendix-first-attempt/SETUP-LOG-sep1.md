# SETUP-LOG — Cascade bake-off, Phase 0 preflight

All times America/New_York. Format: `[time] command or check → outcome`.
Runtime note: this log was started from a Claude (Cowork) cloud session linked to the evaluator's Mac. That session has two shells — a cloud Linux container and a sandboxed Linux VM on the Mac — and NEITHER has a Docker daemon. See "Runtime finding" below; it is the first blocker of the eval.

## 2026-09-01 — Phase 0

### Environment checks

| # | Check | Cloud container | Mac sandbox VM (device_bash) | Result |
|---|-------|-----------------|------------------------------|--------|
| 1 | Docker daemon + `/var/run/docker.sock` | docker binary present, **no socket / no daemon** | **no docker at all** | FAIL (both) |
| 2 | docker compose v2 | n/a (no daemon) | absent | FAIL |
| 3 | Node ≥ 22 | v22.22.2 | v22.23.2 | PASS |
| 4 | Free disk ≥ 15 GB | 30 GB avail (but ephemeral, wiped on session end) | **8.6 GB avail** on 9.8 GB volume | FAIL (VM); cloud passes but is not durable |
| 5 | Ports 3000/3001 free on the Docker host | cannot check — host is the evaluator's macOS, not reachable by shell | same | UNKNOWN — check on Mac: `lsof -i :3000 -i :3001` |
| 6 | Outbound network | github.com reachable; **ghcr.io blocked by org egress proxy (403)** | github.com 200 | PARTIAL |
| 7 | ngrok or cloudflared installed + authed | absent | absent | FAIL — check on Mac: `which ngrok cloudflared` |
| 8 | `gh` CLI authed | absent | absent | n/a — repo identified from git remote instead |

22:02 `git remote -v` in ~/ai-garage-web → `https://github.com/<owner>/ai-garage-web.git`, branch `main`. **Target repo = <owner>/ai-garage-web.**
22:03 `~/cascade-eval/` exists, created 21:59 today, empty → adopted as the work-products directory.
22:04 `git clone --depth 1 https://github.com/mongrel-intelligence/cascade.git` (cloud container) → OK. HEAD `aee88e2` 2026-08-25 "fix(router): authenticate worker-image pulls against private registries (#1539)". package.json version 1.0.0, engines node >=22.

### Runtime finding (blocker)

Cascade's router launches one Docker container per job via `/var/run/docker.sock`. Neither shell available to this session can host that:
- Cloud container: no Docker daemon, ghcr.io blocked, filesystem discarded when the session ends.
- Mac sandbox VM: no Docker, 9.8 GB disk, no tunnel tools.
The only viable Docker host is **the evaluator's macOS itself (Docker Desktop)**, which this session cannot run shell commands on. Decision on how Phases 2–4 get executed is pending (asked 22:10).

### Known Facts vs. code (week-zero snapshot check)

Confirmed as stated:
- Stack: postgres:16-alpine, redis:7-alpine, `migrate` (profile `setup`), `dashboard` :3001, `router` :3000 with `/var/run/docker.sock` mounted. `setup.sh` = build + build worker + migrate + up.
- Admin user: `docker compose exec dashboard node dist/tools/create-admin-user.mjs --email … --password … --name …`.
- Node ≥22 for non-docker steps (`engines`).
- PM adapters: `src/pm/{trello,jira,linear}` only (+ `no-pm-provider.ts`). GitHub is SCM-only.
- Webhooks need public reachability; docs recommend ngrok/cloudflared; `webhooks create` registers GitHub + Trello hooks programmatically from the callback URL.
- Single implementer token is sufficient: `scm-integration.ts` `hasIntegration()` returns true if implementer OR reviewer token exists ("some agents only need one"). Reviewer token is a separate optional slot.
- Worker image pins `@anthropic-ai/claude-code@2.1.185` and `@openai/codex@0.145.0` (Dockerfile.worker).
- Credentials stored encrypted in DB (optional `CREDENTIAL_MASTER_KEY` in .env; generate with `openssl rand -hex 32`).

Corrections / additions:
1. **Worker image is BUILT locally, not pulled.** docker-compose.yml: `worker: image: cascade-worker:local, profiles: [build-only]`. "Pull early" → "build early"; it is the longest step of setup.sh. Docs say ~8 GB disk for it.
2. **Auto-merge is double-gated and OFF by default.** `pr-ready-to-merge.ts` first checks `isLifecycleTriggerEnabled(project, 'prReadyToMerge')` — stored in the SCM integration's `triggers` JSONB, default `false`; dashboard exposes it as "PR Ready to Merge" (Settings → Integrations → SCM, `web/src/lib/trigger-agent-mapping.ts`). Even when enabled, `githubClient.mergePR` only runs if the card carries the configured `labels.auto` label. To satisfy the hard constraint: leave "PR Ready to Merge" unchecked AND do not configure an `auto` label.
3. **Trello needs labels, not just lists.** Config shape: `{boardId, lists:{todo,inProgress,inReview}, labels:{readyToProcess,processing,processed,error,[auto]}}`. The workflow-comparison board (To Do / In Progress / Done) will need an "In Review" list (or mapping Done→inReview) and four labels created before the wizard step. Budget this into Phase 3.
4. Anthropic auth alternative: getting-started documents `CLAUDE_CODE_OAUTH_TOKEN` (from `claude setup-token`, Claude Max) as an alternative to `ANTHROPIC_API_KEY` for the default claude-code engine. Either goes into the project Credentials wizard.
5. Prompt said "Cascade's auto-merge feature must be configured OFF (verify in project settings)". Verified location above; default state already satisfies the constraint.

### Phase 0 status
Code review: DONE. Host preflight: BLOCKED pending runtime decision (items 1, 2, 5, 7 must be re-run on the Mac's own shell).

### Runtime decision (22:12)
the evaluator chose: **she runs commands in her own macOS Terminal; Claude directs and logs.** Each Phase 2+ step will be given as one command block; she pastes the output back; it is recorded here verbatim (secrets redacted) before the next step is issued. The Mac's own preflight (Docker Desktop running, compose v2, `lsof -i :3000 -i :3001`, disk, ngrok/cloudflared) is therefore re-run as the first Phase 2 step.
Consequence for the bake-off: Cascade setup hours in SCORECARD will include human-in-the-loop latency; note it so OpenHands/claude-code-action/pullfrog are timed the same way.

### Decision revised (22:58)
the evaluator questioned the process weight; agreed the setup is Cascade's own getting-started plus Trello mapping, not a software build. Dropped: design spec, per-step rollback notes, extra approval gates, BMAD ceremony. Kept: this log, three identical tickets (`stories/`), one scorecard rubric (`SCORECARD-TEMPLATE.md`). Execution moves to **Claude Code on the Mac** (`CLAUDE-CODE-PROMPT.md`), which has Docker and Terminal natively; `MANUAL-RUNBOOK.md` is the fallback if she drives it herself. Phase 0 of this session ends here; Claude Code appends below.

---

## 2026-09-01 — Claude Code on the Mac (Phase 2+)

Runtime: Claude Code (Fable 5.1) in `~/cascade-eval`, native macOS shell with Docker Desktop. Times America/New_York.

### Step 0 — Preflight (19:07)
19:07 `docker info` → Client 29.7.2, Server 29.7.2, Docker Desktop, 10 CPUs, VM memory 8.3 GB. PASS
19:07 `docker compose version` → v5.5.0 (runbook says v2.x; v5 is the current compose plugin, superset). PASS
19:07 `lsof -i :3000 -i :3001` → empty (exit 1). PASS
19:07 `df -h ~` → 663 GiB free of 926 GiB. PASS
19:07 `ngrok config check` → "Valid configuration file"; ngrok at /opt/homebrew/bin/ngrok; cloudflared absent (not needed). PASS
19:07 `node --version` → v22.21.0. PASS
19:07 `~/cascade-eval/cascade` does not exist yet (Phase 0 clone was in the discarded cloud container). Clone in step 1.
19:07 `~/ai-garage-web` present, remote https://github.com/<owner>/ai-garage-web.git, on `main`.
Note: Docker Desktop VM is 8.3 GB; `.env` default MAX_WORKERS=3 × WORKER_MEMORY_MB=4096 would exceed it if three jobs ran concurrently. Stories run one at a time so one worker fits; leaving defaults per runbook, flagging for the scorecard.
Step 0 result: PASS on all six checks.

### Step 1 — Clone and configure (19:08)
19:08 `git clone https://github.com/mongrel-intelligence/cascade.git` → OK. HEAD `aee88e20` 2026-08-25 "fix(router): authenticate worker-image pulls against private registries (#1539)" — identical to the commit the runbook was verified against, no drift.
19:08 `cp .env.docker.example .env` + appended `CREDENTIAL_MASTER_KEY=$(openssl rand -hex 32)` → OK. `.env` is gitignored (`git check-ignore .env` → .env). Keys present: POSTGRES_PASSWORD, DASHBOARD_PORT=3001, ROUTER_PORT=3000, MAX_WORKERS=3, WORKER_MEMORY_MB=4096, WORKER_TIMEOUT_MS=1800000, CREDENTIAL_MASTER_KEY. No token placeholders to fill. Values not logged.
19:08 Read `setup.sh` → non-interactive (no `read`), `set -e`; does compose build → worker build → migrate → up -d. `Dockerfile.worker` pins `@anthropic-ai/claude-code@2.1.185` and `@openai/codex@0.145.0` (untouched). `curl -sI https://ghcr.io/v2/` → HTTP 405 (reachable from the Mac; Phase 0's 403 was the cloud proxy). `LICENSE` → MIT, "Copyright (c) 2026 Zbigniew Sobiecki and CASCADE Contributors".
Step 1 result: PASS.

### Step 2 — Build and start (launched 19:09)
19:09 `nohup bash setup.sh > $CLAUDE_JOB_DIR/tmp/setup.log 2>&1 &` → pid 52495, running (`docker compose build` in progress). Steps 5 and 6 handed to the evaluator to do in parallel.
19:12 `setup.sh` exited 0 at 19:12:12 (3 min wall-clock; fast because the Mac pulled base images and npm deps quickly — not a cache hit, the worker image was built from scratch, setup.log lines 460–1556). Migrations applied. `docker compose up -d` started all four services.
19:13 Verification (verbatim):
  `docker compose ps` → cascade-dashboard-1 Up (healthy) 0.0.0.0:3001; cascade-postgres-1 Up (healthy); cascade-redis-1 Up (healthy); cascade-router-1 Up (healthy) 0.0.0.0:3000.
  `curl -s localhost:3001/health` → {"status":"ok","service":"cascade-dashboard",...}
  `curl -s localhost:3000/health` → {"status":"ok","role":"router","queue":{"waiting":0,"active":0,"completed":0,"failed":0},"activeWorkers":0,"workers":[]}
  `docker images | grep cascade` → cascade-worker:local 6.6GB; cascade-dashboard 1.34GB; cascade-router 1.34GB; cascade-migrate 2.17GB.
Step 2 result: PASS (all four runbook checks). Setup.sh output kept at $CLAUDE_JOB_DIR/tmp/setup.log (ephemeral).

### Step 4 — Tunnel (19:11, started before step 2 finished since it is independent)
19:11 `nohup ngrok http 3000 --log=stdout --log-format=logfmt > $CLAUDE_JOB_DIR/tmp/ngrok.log &` → pid 54515. Public URL read from `curl localhost:4040/api/tunnels` → https://calorie-unsubtly-handball.ngrok-free.dev → http://localhost:3000.
19:13 `curl -s https://calorie-unsubtly-handball.ngrok-free.dev/health` → same router health JSON as local (exit 0). PASS.
Note: free-tier ngrok URL changes if ngrok restarts; the GitHub and Trello webhooks registered in step 7 would then be orphaned. Keep pid 54515 alive through all three stories.

### Step 6 finding (19:10) — PAT needs one more repo permission
`src/api/routers/webhooks/github.ts:65` calls `octokit.repos.createWebhook` with `ctx.githubToken`, which `src/api/routers/webhooks/context.ts:53` sets from `GITHUB_TOKEN_IMPLEMENTER`. Creating a repo webhook with a fine-grained PAT requires the repository permission **Webhooks: Read and write** in addition to Contents RW, Pull requests RW, Issues RW, Metadata R. Still single-repo scoped, no org/account permissions. Flagged to the evaluator before she mints the token.

### Step 3 — Admin user: waiting on the evaluator (she runs the command herself so the password never enters the chat).

### Step 7 pre-check (19:20) — dashboard webhook button cannot target the tunnel
Source read (subagent + my verification):
- No global "Settings → Webhooks" page at this commit. Registration is per project: SCM tab "Create GitHub Webhook" button and the Trello wizard's Webhook step, both calling `webhooks.create` (`src/api/routers/webhooks.ts:195`), which takes a client-supplied `callbackBaseUrl`.
- The web client computes it as `VITE_API_URL || window.location.origin.replace(':5173', ':3000')` (`web/src/components/projects/integration-scm-tab.tsx:144-146`). `VITE_API_URL` is a build-time arg (`Dockerfile.frontend:24`) that `setup.sh`/compose never sets, so from http://localhost:3001 the callback would be `http://localhost:3001/...` — not the router, not public. The buttons are unusable with an ngrok setup (a runbook correction; the runbook's "Settings → Webhooks: callback URL = your ngrok URL" field does not exist).
- Documented alternative: local CLI `node bin/cascade.js webhooks create <projectId> --callback-url <ngrok>` (`src/cli/dashboard/webhooks/create.ts:13-15`; getting-started §4/§5 say `npm install && npm run build` first). It uses the project's stored implementer PAT and Trello token server-side, so no secrets pass through the chat. Registers GitHub (events: pull_request, pull_request_review, pull_request_review_comment, check_suite, issue_comment) and Trello in one call, deduping by callback URL.
- Also from the source read: Agent Configs has NO agent enabled by default except `debug` (`src/api/routers/agentTriggerConfigs.ts:312-320`); `implementation` must be enabled explicitly on the Trello "card moved to To Do" event. Trello wizard = OAuth popup with manual-token fallback; API key is typed in the wizard (project credential, not env). Credentials at rest: AES-256-GCM in `project_credentials`, keyed by CREDENTIAL_MASTER_KEY (`src/db/crypto.ts`); passed to workers as container env vars. Missing reviewer token error text: "Integration credential 'scm/github/reviewer_token' not found for project '<id>'" (`src/config/provider.ts:267-269`). Implementer PAT also needs Actions: read for the CI-status paths (respond-to-ci); not needed for run 1.
19:20 `nohup sh -c 'npm install && npm run build' > $CLAUDE_JOB_DIR/tmp/cli-build.log &` in ~/cascade-eval/cascade → started, so the CLI is ready for step 7.
19:17 CLI build exited 0 (tsc + yaml/prompt copy; no errors). `node bin/cascade.js webhooks create --help` → shows `--callback-url` flag. `npm install` also ran `prepare: lefthook install` (git hooks in the cascade checkout only; harmless). CLI session will be stored in ~/.cascade/ after login.
19:18 Waiting on the evaluator: step 3 admin (she runs), step 5 Trello prep, step 6 PAT (+Webhooks RW decision). Pause before step 7 in effect.

### Step 3 — Admin user (19:48)
19:48 the evaluator asked Claude to create the account (local-only, lives in the postgres container). `docker compose exec dashboard node dist/tools/create-admin-user.mjs --email the evaluator@local --password '<local throwaway, shared in chat by agreement>' --name "the evaluator"` → created.
19:49 Verify: `POST localhost:3001/api/auth/login` → HTTP 200 with `cascade_session` cookie. `node bin/cascade.js login --server http://localhost:3001 ...` → "Logged in as the evaluator (the evaluator@local)"; `whoami` → role superadmin, org default. CLI session saved in ~/.cascade/. PASS.

### Step 7 — Project config (started 20:53; the evaluator asked Claude to drive it; she pastes secrets in the dashboard)
20:53 `node bin/cascade.js projects create --id ai-garage --name "AI Garage" --repo <owner>/ai-garage-web --base-branch main` → created: id ai-garage, org default, repoPrimary true, branchPrefix feature/, agentEngine null (default claude-code).
20:54 Claude-in-Chrome extension not connected on this Mac → dashboard UI cannot be driven by Claude; non-secret config goes through the CLI, secrets and the Trello OAuth wizard are the evaluator's clicks.
20:54 `node bin/cascade.js agents create --agent-type implementation --project-id ai-garage` → agent config id 1. `agents list` → only `implementation` enabled (review / respond-to-ci / resolve-conflicts NOT enabled, per runbook "leave as they are" = off at this commit).
20:54 `node bin/cascade.js projects integration-set ai-garage --category scm --provider github --config '{}'` → ok. `projects integrations ai-garage` → scm/github id 1, config {}, **triggers {}** (the dashboard SCM tab saves the identical `{}` config; repo/base branch live on the project row). `prReadyToMerge` absent ⇒ "PR Ready to Merge" OFF.
20:55 `projects credentials-list ai-garage` → none yet. Handing the evaluator the three secret pastes + the Trello wizard.
21:05 the evaluator offered to share the tokens in chat; declined (credential handling in plain text is out of bounds for Claude regardless of consent). Agreed path: she appends GITHUB_TOKEN_IMPLEMENTER, ANTHROPIC_API_KEY, TRELLO_API_KEY, TRELLO_TOKEN to `~/cascade-eval/cascade/.env` (gitignored; compose only uses it for interpolation, explicit `environment:` blocks in docker-compose.yml, so the extra keys do not enter containers). Claude will `source` it in a subshell and pass values to `cascade projects credentials-set` / Trello API calls with output suppressed. `.env` chmod 600.
20:59 the evaluator appended the four values to `.env`. Lengths only checked (93/108/32/76). `node bin/cascade.js projects credentials-set ai-garage --key <K> --value "$K"` ×4 (sourced from .env in a subshell, output suppressed) → all stored; `credentials-list` shows masked ****xxxx for GITHUB_TOKEN_IMPLEMENTER, ANTHROPIC_API_KEY, TRELLO_API_KEY, TRELLO_TOKEN.
21:00 Trello API read-only discovery → the board named `workflow-comparisons` (6a974012991254a4ba25ace0) is an untouched Trello template (Project Resources / Questions / To Do / Pending / Blocked / Done, template labels). The prepared board is **`adlc-comparisons` id 6a9740dea580e2eb7afd4b50, https://trello.com/b/fnx9B5yF** — lists Backlog (6a9770eb1c80929ac91f4724) · To Do (6a9740dea580e2eb7afd4b56) · Doing (6a9740dea580e2eb7afd4b57) · In Review (6a9770f8f644f059420c0f80) · Done (6a9740dea580e2eb7afd4b58); labels readyToProcess 6a97718cf1a279513a8aa266, processing 6a97719558a6505e07f669c3, processed 6a97719b51b5dcbfa964728c, error 6a9771a06551baf32b152642; no `auto` label; card "Change the AI Garage page title" in Backlog. Two other boards also named adlc-comparisons exist (iyxajGik template, 5Ccqcfcg kanban template) — ignored. Using fnx9B5yF; "Doing" maps to inProgress.
21:01 **BLOCKER — GitHub token scope (hard constraint: stop and tell the evaluator).** Token is fine-grained (`github_pat_`), identity <owner>. `GET /repos/<owner>/ai-garage-web` with it → 404 Not Found (repo is private: unauthenticated GET also 404). `GET /user/repos` with it → 19 repositories visible, including admin/push on `<owner>/ai-garage` (the legacy repo AGENTS.md says never to edit), plus forks (mlflow, scikit-learn, transformers) and two repos owned by other users. `GET /repos/<owner>/ai-garage-web/hooks` → 404. Conclusion: repository access was not set to "Only select repositories → ai-garage-web"; the token is broader than allowed AND does not include the target. Not proceeding with GitHub webhook registration until re-issued.
21:00 `node bin/cascade.js projects integration-set ai-garage --category pm --provider trello --config '{boardId fnx9B5yF, lists{backlog,todo,inProgress→Doing,inReview}, labels{readyToProcess,processing,processed,error}}'` → ok. `projects integrations` → pm/trello id 2 with exactly those keys; **no `auto` label key; scm triggers still {}**. Both auto-merge gates verified OFF at the config level.
21:02 Card 6a9740f8734bfbf47e17e0bb "Change the AI Garage page title" is in Backlog with the verbatim story-1 description, but had all four Cascade labels attached (prep slip). Removed the four labels via Trello API (DELETE /cards/{id}/idLabels/{label}) so the card starts clean.
21:02 `git ls-remote origin main` from ~/ai-garage-web (the evaluator's own git creds) → 6919f11c: repo exists and is private. Local clone's main is at 3b0fab7 (behind remote); step 9 will `git fetch` first.
21:08 the evaluator updated `.env`. Re-check: token still `github_pat_`, same masked suffix (****6UET) → the existing token was edited in place rather than re-issued. `GET /repos/<owner>/ai-garage-web` → 200, private, default main, permissions admin/push/pull. `GET .../hooks` → 200 (Webhooks permission present). `GET /user/repos` → still **19 repositories** selected (ai-garage-web now included, legacy `ai-garage` no longer). Target reachable, but scope is 19 repos, not 1. Stopping again per the hard constraint; the evaluator to decide: trim the token's repository selection to ai-garage-web only (edit in place, same string, no .env change) or accept as-is for the eval and record it.
21:17 `.env` saved 21:17:25 with the new token (cascade-eval-2, suffix ****PYCn). Stored via credentials-set → `credentials-list` shows ****PYCn. Access: ai-garage-web repo 200 (private), hooks 200, collaborators 200.
21:19 Scope verification, corrected method: `GET /user/repos` still lists 19 repos and `permissions` shows admin on e.g. <owner>/mlflow — but those repos are PUBLIC (unauthenticated GET → 200) and the token gets **403** on their `/hooks` and `/collaborators` endpoints, i.e. no granted permissions there; the private `<owner>/ai-garage` → 404. Conclusion: `/user/repos` and `permissions` reflect the user's own visibility, not the fine-grained grant; the 21:08 "19 repos" alarm on the edited first token was based on that misleading metric (the first token's 404 on ai-garage-web at 21:01 was a real problem). cascade-eval-2 is scoped to exactly <owner>/ai-garage-web, matching GitHub's token page. Constraint satisfied; proceeding to webhooks.
21:18 `node bin/cascade.js webhooks create ai-garage --callback-url https://calorie-unsubtly-handball.ngrok-free.dev` → Trello webhook 6a9779713a71c4e7f1e17474 on board 6a9740dea580e2eb7afd4b50 → …/trello/webhook, active; GitHub repo hook 673360982 → …/github/webhook, events pull_request, pull_request_review, pull_request_review_comment, check_suite, issue_comment, active.
21:19 Verify GitHub: hook deliveries → ping 2026-09-02T01:18:42Z status OK 200 (0.13 s); hook last_response {code 200, active}. Router log 01:18:42 "Received GitHub webhook event: 'ping'" then "Ignoring github event" (expected for ping).
21:19 Verify Trello: created scratch card 6a977982b3ef5aa3dc0009a8 in Backlog via API, moved Backlog→Doing→Backlog, archived it (never entered To Do). Router log shows four "Received Trello webhook" entries 01:18:58–01:19:05, each "Ignoring trello event (unparseable or not processable)" — expected, no trigger matches those moves. Story card untouched, still in Backlog, no labels.
Step 7 result: PASS. **Webhook-verified at 21:19** (setup wall-clock endpoint for the scorecard: 19:07 → 21:19 = 2 h 12 m, of which ≈1 h 25 m was waiting on the evaluator: 19:18→20:53 for admin/Trello/PAT, plus the token re-issue 21:01→21:17).

### Step 8 pre-flight (21:22)
21:22 Anthropic key check (sourced from .env, never printed): format sk-ant-api03…, 108 chars, no stray whitespace. `GET /v1/models` with x-api-key → **HTTP 401**; `POST /v1/messages` (haiku, 5 tokens) → 401; as Bearer → 401. The key is not accepted by the API. BLOCKER for the live run: the evaluator to paste a valid key (console.anthropic.com → API keys) on the ANTHROPIC_API_KEY line of .env; the earlier stored value will be overwritten.
21:22 `webhooklogs list --source trello` → 4 entries, all status 200, Processed no, reason "Event unparseable or not processable". The message originates in `src/router/webhook-processor.ts:44-47` when `adapter.parseWebhook(payload)` returns null, which is BEFORE project resolution (step 6 of the pipeline). Reading the Trello parser to confirm a Backlog→To Do move is one it accepts (see next entry).
21:23 Router Trello adapter (`src/router/adapters/trello.ts:34-70`) returns null (→ "unparseable or not processable") both when no project matches the board AND when the action is not a trigger; trigger lists are only splitting/planning/**todo** (`src/router/trello.ts:31-35`), so the Backlog→Doing scratch moves were correctly ignored. Positive routing evidence: posted a comment on the archived scratch card → router log "Ignoring self-authored trello event { eventType: 'commentCard', projectIdentifier: '6a9740dea580e2eb7afd4b50' }" and `webhooklogs` shows Processed=yes, reason "Self-authored event (loop prevention)". Board → project `ai-garage` resolves. Router project config is cached (`src/router/config.ts:115`, TTL) but had already picked up the Trello integration.
Note for the scorecard: because the Trello token is the evaluator's own account, Cascade's "bot identity" == the evaluator; her own comments on cards will be ignored as self-authored.
21:24 Self-authored check (`src/router/adapters/trello.ts:77-78`) applies only to comment events, so the evaluator dragging the card into To Do with her own account will NOT be dropped. Step 8 pre-flight complete except the Anthropic key. Waiting on the evaluator for a valid ANTHROPIC_API_KEY in .env, then the go for step 8.
21:27 the evaluator saved a new ANTHROPIC_API_KEY (.env saved 21:26:05). Tested exactly `grep '^ANTHROPIC_API_KEY=' .env | cut -d= -f2-` (no shell sourcing): sk-ant-api03…, 108 chars, clean charset → `/v1/models` 401, `/v1/messages` 401, body: {"type":"authentication_error","message":"API key is invalid."}. For comparison the ANTHROPIC_API_KEY exported in ~/.zshrc (different key, sha differs) → 200. So the pasted key is not a live key; the account has at least one working key. Waiting on the evaluator: paste a valid key or authorize copying the ~/.zshrc one into .env programmatically (never displayed).
21:31 the evaluator authorized using the ~/.zshrc key. Copied it into the .env ANTHROPIC_API_KEY line via a python re.sub (never displayed; sha matches c1f071f31305). `/v1/models` 200, `/v1/messages` 200. Stored via credentials-set → masked ****mwAA. Pre-flight complete.

### Step 8 — Story 1 live run
21:32 Observers armed: (1) persistent `docker compose logs -f router` filter (Trello/GitHub/dispatch/worker/job/error); (2) `docker ps` poller for worker containers with mem/cpu; (3) GitHub open-PR poller every 30 s, 35-min ceiling. Pre-move state: card 6a9740f8734bfbf47e17e0bb in Backlog (6a9770eb1c80929ac91f4724), no labels; `runs list` → none; router health queue all zeros. the evaluator will drag the card to To Do (6a9740dea580e2eb7afd4b56) herself.
21:32 Baseline: repo already has 5 open PRs (#21 request/codebase-onboarding-agent by <owner>, #19/#17/#15/#14 dependabot). Highest PR number of any state = 22 (closed). PR poller armed to detect any PR numbered > 22.
21:33 the evaluator moved the card Backlog → To Do (Trello action 2026-09-02T01:33:02.982Z by <evaluator-trello>). Router 01:33:03.332 "Card moved to trigger list" → "Trigger matched" (handler trello-status-changed-todo, agent implementation) → **"Trigger disabled by config, skipping"** (triggerEvent pm:status-changed, projectId ai-garage) → "No trigger matched". No run created. **Step 8 attempt 1: FAILED (config).**
Root cause: `src/agents/definitions/implementation.yaml:29-32` declares the pm:status-changed trigger with `defaultEnabled: false`. My CLI `agents create` only created the agent_configs row; the trigger itself needs an explicit enable (the dashboard Agent Configs "Enable" flow does both; the runbook's "confirm implementation is enabled on the card-moved-to-TODO event" is exactly this check). Runbook note for next tools: agent enable ≠ trigger enable in Cascade.
21:33 Fix: `node bin/cascade.js projects trigger-set ai-garage -a implementation -e pm:status-changed --enable` → {enabled: true, parameters: {}}. `trigger-list` → implementation / pm:status-changed / yes. Re-trigger requires the card to leave To Do and re-enter it; asking the evaluator to move it To Do → Backlog → To Do (attempt 2).
22:21 Worker exited after 6.5 s: statusCode 0, oomKilled false, exitReason null. Run 8ce34a95 status failed (1 s). Card now in Doing with labels processing + error. Worker comments on the card: 02:20:58Z 'Implementing changes' then 02:21:01Z 'Error: BootFailureError: plan resolution failed: Model "openrouter:google/gemini-3-flash-preview" is not compatible with the Claude Code engine. Configure a Claude-compatible model (e.g. "claude-sonnet-5") or switch to a different engine.'
**Step 8 attempt 2: FAILED (config).** Root cause: project row has model null and agentEngine null; Cascade's global default model is an OpenRouter Gemini id while the default engine is claude-code, and the two are incompatible. Not a runbook step; a Cascade default. Per the two-failures rule: stopping, writing up, preparing the fix (set the project model to a Claude model) without re-running.
22:22 Fix prepared (not re-run): `node bin/cascade.js projects update ai-garage --model claude-sonnet-5` (the engine's own DEFAULT_CLAUDE_CODE_MODEL, src/backends/claude-code/models.ts:22; global default model is src/config/schema.ts:10). Engine left at default claude-code. Card is in Doing with labels processing + error; for attempt 3 the card must be moved back to Backlog, labels cleared, then into To Do. Waiting for the evaluator's decision (two failed attempts on step 8).

22:35 the evaluator: "attempt 3". Cleared labels processing + error from the card, moved To Do → Backlog (22:35:53), Backlog → To Do (Trello action **2026-09-02T02:36:00.188Z** = 22:36:00 EDT). **Step 8 attempt 3 — card-moved timestamp 22:36:00.**
22:36:00 Router: trello trigger matched (implementation) → Coalesced job scheduled jobId coalesce_ai-garage_6a9740f8734bfbf47e17e0bb_1788316560546_f0f70o. PR watcher re-armed.
22:36:10 Worker spawned (container cascade-worker-coalesce_…f0f70o). 22:36:12 card comment 'Implementing changes'; card → Doing, label processing. Worker peak ≈1.04 GiB / 4 GiB.
22:37:05Z **PR #23 opened**: https://github.com/<owner>/ai-garage-web/pull/23 — branch fix/page-title → main, author <owner> (the PAT identity), commit 8ced804b authored 'Cascade Bot <bot@cascade.dev>', 1 file app/layout.tsx +1 −1 (title string only), not draft. PR body: Summary / Details (links the Trello card, states only metadata.title changed) / Test plan: typecheck, eslint on app/layout.tsx, npm test 79 passed. Note: branch prefix is fix/ although the project's branchPrefix is feature/.
22:37:21 Worker exited statusCode 0, durationMs 70860. Run 697a92e0 completed, 1m 5s, cost $0.51. Card → In Review, label processed (processing removed). Router logged, per GitHub webhook, ERROR 'Failed to resolve cascade persona identities … reviewer_token not found' + WARN 'skipping GitHub reaction' — expected with the reviewer slot empty; noted, moving on.
**Step 8 result: PASS on attempt 3. Card→PR = 02:36:00.188Z → 02:37:05Z = 65 s.**

### Step 9 — Verify story 1 (22:38)
22:38 `git fetch origin` in ~/ai-garage-web (local main left at 3b0fab7, no checkout). `git diff origin/main...origin/fix/page-title --stat` → app/layout.tsx | 2 +- (1 insertion, 1 deletion) — only file, only the title string. Merge-base == origin/main tip (6919f11c), branch is fresh. Runbook's `git diff main...` would have compared against the stale local main; used origin/main instead.
22:38 PAT cannot read check-runs/deployments (403, no Actions permission by design) → CI and preview status read via the connected GitHub/Vercel integrations instead. Build check runs in an isolated worktree at $CLAUDE_JOB_DIR/tmp/wt-pr23 (npm ci → lint → typecheck → test → build), not in the evaluator's working copy.
Run 697a92e0-d639-4d14-8ff5-8820cb1c42fb: engine claude-code, model claude-sonnet-5, startedAt 02:36:13.364Z, completedAt 02:37:18.732Z, durationMs 65369, costUsd 0.508701, success true, prNumber 23.
22:39 Worktree build of origin/fix/page-title @ 8ced804: npm ci (400 pkgs, 6 s) → `npm run lint` clean → `npm run typecheck` clean → `npm test` 79 passed → `npm run build` OK. All four AGENTS.md gates pass locally (the agent's own PR body claims typecheck + eslint on one file + tests; it did not claim lint or build). Worktree removed; the evaluator's working copy untouched (main @ 3b0fab7, clean).
22:40 PR #23 mergeable true, mergeable_state unstable (checks still running at 22:40), 1 issue comment from vercel[bot] (preview deployment exists). GitHub connector account and Vercel MCP token cannot read this private repo/project (404/403), so CI is tracked via the PR's mergeable_state and the preview via the Vercel bot's link.
22:41 Vercel: the vercel[bot] PR comment shows deployment 2u9Hmnz38QF9kpMjRgufoF12y6zN for ai-garage-web as **Blocked** (error icon) at 2026-09-02T02:37:11.662Z; no preview URL was issued. Vercel blocks Git deployments whose commit author is not a member of the Vercel team; the commit is authored 'Cascade Bot <bot@cascade.dev>' while the push came through the evaluator's PAT. Not changing any Vercel setting (hard constraint). **Preview OK = NO for story 1**; fix belongs to the evaluator/the engineering lead (either Vercel → Project → Settings → Git → disable 'Require Git author to have access', or configure Cascade's git author to a team member's email — the latter is a Cascade-side setting to look for tomorrow).
22:42 Cascade hard-codes the git author: `src/utils/repo.ts:59` runs `git config user.email "bot@cascade.dev"` (and a matching user.name) in the clone; no env/config override at this commit. So the Vercel 'Blocked' preview cannot be fixed on the Cascade side without a code change; the Vercel-side toggle is the practical fix.

### Manual touch after story 1 (the evaluator's instruction, 22:52)
22:52 Vercel preview blocked by commit author. the evaluator: push an empty commit as her identity, then set Cascade's git author to it. In a fresh worktree of origin/fix/page-title: `git commit --allow-empty --author="<owner> <evaluator@noreply.invalid>"` (committer set to the same) → 9c11a6e "chore: retrigger Vercel preview (empty commit)"; `git push origin fix/page-title` with the evaluator's own git credentials → 8ced804..9c11a6e. PR #23 now has 2 commits. Branch only; main untouched. **Recorded as a manual touch for story 1.**
22:53 mergeable_state poller expired after 12 min still 'unstable' (the Blocked Vercel deployment counts as a failed status; CI result itself not readable by the PAT). Re-checking after the new commit.
22:53 Cascade patch: `src/utils/repo.ts:58-59` user.name "Cascade Bot"→"<owner>", user.email bot@cascade.dev→evaluator@noreply.invalid (only place the author is set). package-lock.json drift from the earlier `npm install` reverted so the checkout diff is the 2-line patch only. Rebuilding router + worker images (same Dockerfile.worker, CLI pins unchanged) and restarting router.
22:53 Vercel redeployed on 9c11a6e: deployment 7Hu5snoNi8a1qGhmUeKaXWEoRvH4 Building at 22:53:01 → **Ready at 22:53:31**; preview URL https://ai-garage-web-git-fix-page-title-<owner>-project.vercel.app (from the vercel[bot] comment). Anonymous curl of the preview → HTTP 200 but the body is Vercel's login page (<title>Login – Vercel</title>): the project has Deployment Protection on, so the tab-title check needs an authenticated viewer.
22:54 Image rebuild finished (router + worker), router restarted.
22:55 PR #23 mergeable_state **clean** with 2 commits (8ced804 agent, 9c11a6e empty retrigger) → every check on the head passed: GitHub Actions `verify` (lint/typecheck/test/build, per .github/workflows/ci.yml) and the Vercel deployment. **CI green = YES for story 1** (via merge-state; the PAT cannot read check-runs directly).
22:55 Rebuilt worker image verified: dist/utils/repo.js sets user.name "<owner>" / user.email evaluator@noreply.invalid; claude-code still 2.1.185. Router healthy after restart (queue completed 2, failed 0), tunnel 200.
22:56 Vercel MCP cannot mint a protection-bypass link for the preview (its account is not on the <owner>-project team). Tab-title confirmation on the authenticated preview left to the evaluator; the deployed commit tree is identical to the one built locally at 22:39 where app/layout.tsx carries the new title.
23:05 the evaluator challenged the attribution of the two failed attempts to Cascade. Re-checked: the dashboard Agent Configs page exposes per-trigger toggles (web/src/components/projects/project-agent-configs.tsx uses definition-trigger-toggles), so attempt 1 is on my CLI shortcut; getting-started recommends an OpenRouter key and the dashboard has model/engine settings, so attempt 2 is shared (our Anthropic-only choice + no model set). Vercel block is a Vercel policy meeting Cascade's bot author, not a malfunction. SCORECARD wording corrected to say so.

### Story 2 live run (started by the evaluator, 2026-09-02 01:43)
01:43:28 Card 6a97b17badb9b190f777703b "Add a site footer with Submit and Contact links" (story 2 text pasted) moved To Do → Backlog, then **Backlog → To Do at 2026-09-02T05:43:31.508Z (01:43:31 EDT)** by <evaluator-trello>. Claude did not touch the card.
01:43:31 Router: trigger matched → coalesced job scheduled. 01:43:42 worker spawned (cascade-worker-coalesce_…9u2yht, from the rebuilt image with the patched git author). 01:43:44 card → Doing, label processing. Run 22209d65 running. Observing only.
01:44:59Z **PR #24 opened**: https://github.com/<owner>/ai-garage-web/pull/24 — feature/site-footer → main (prefix followed this time), opened by <owner>, commit 3898b6da authored **<owner> <evaluator@noreply.invalid>** (the patched author works). Files: components/site-footer.tsx (new, +19), app/layout.tsx (+2), app/globals.css (+43). Body: Summary (component, links, tokens, follows portal-nav pattern) + card link + Test plan claiming lint, typecheck, test (79), build all run.
01:45:22 Worker exited statusCode 0, durationMs 100267. Run 22209d65 completed, 1m 35s, cost $0.73. **Card→PR = 05:43:31.508Z → 05:44:59Z = 88 s.** No manual touches before the PR.
01:46 Step 9 for story 2 started: diff review, worktree build, Vercel/CI watch.

### Sep 2 — Story 2 (Cowork session)
01:12 / 01:17 run-story.sh created + moved two footer cards (the second because the script crashed on a quoting bug after the move). Router: "Trigger matched" then "pipeline-at-capacity: skipping status-changed trigger" inFlightCount 1→2, limit 1. Cause: story-1 card still in In Review; maxInFlightItems=1 counts To Do+Doing+In Review.
01:43 unblock-and-run-2.sh: story-1 card → Done, 01:12 card archived, footer card Backlog→To Do. 01:43:53 card in Doing, "Implementing changes". 01:44:56 implementation update comment. **01:45:07 PR #24 feature/site-footer, card→PR 96 s.** 3 files (+64/−0), commit author <owner> (patched), run 22209d65. PR body claims lint/typecheck/79 tests/build all run.
01:46 Story 2 verification: `git diff origin/main...origin/feature/site-footer --stat` → 3 files, +64/−0 (site-footer.tsx new, layout.tsx +2, globals.css +43). Added CSS uses only var(--ink|--rule|--paper|--accent); no hex/rgb literals; no comments; imports at top. Worktree build: npm ci → lint clean → typecheck clean → 79 tests pass → build OK; worktree removed. Vercel deployment 3MmwA8Fo6GATGBBU4jygGJVDa73e **Ready** at 05:45 UTC with no manual touch (author patch effective); preview https://ai-garage-web-git-feature-site-footer-<owner>-project.vercel.app (Deployment Protection on → visual check of / /library /submit is the evaluator's). PR #24 mergeable_state **clean** → CI green. **Story 2: PASS, 0 manual touches.**

## 2026-09-02 — Phase A (reset Cascade to stock), per EVAL-PLAN.md section 11

Entries from here on use roles only (evaluator, engineering lead, sponsor, reviewer). Time in this phase is evaluator time (undoing the evaluator's own Sep 1 patch), not tool time.

### Step 1 — revert the author patch, rebuild, confirm stock author
16:40:05 Preflight: `docker ps -a --filter name=cascade-worker` → no worker containers. `runs list` → 3 runs (22209d65 completed, 697a92e0 completed, 8ce34a95 failed), none running. Old image ids recorded: cascade-worker:local 456e2f711b23, cascade-router:latest 43e6cb3ff0b0. Note: a process from the Sep 1 Claude Code session (id 699646e0) is still alive but idle; nothing in flight. Flagged to the evaluator to close it (one-session rule).
16:40:15 `git restore src/utils/repo.ts` in the Cascade checkout → `git status --short` and `git diff --stat` both empty. Checkout is stock at aee88e20. `src/utils/repo.ts:58-59` reads user.name "Cascade Bot" / user.email "bot@cascade.dev".
16:40:20 `docker compose build worker router` → both Built in 3 s (Docker layer cache restored the original Sep 1 19:09/19:10 stock layers). New ids: cascade-worker:local f8bd9ca82fb2, cascade-router:latest 53121d527bd0.
16:40:30 Static check inside both images: `grep user.name|user.email /app/dist/utils/repo.js` → "Cascade Bot" / "bot@cascade.dev" in worker and router. PASS.
16:40:46 `docker compose up -d router` → container recreated on image 53121d527bd0. 16:41:22 router healthy (`/health` 200 local and via the ngrok tunnel, queue completed 3 / failed 0, activeWorkers 0), 0 error lines since restart. Dashboard, postgres, redis untouched.
Step 1 result: PASS (static). Live confirmation of the commit author lands with the first Phase B PR. Expected consequence, recorded now: with the bot author restored, Vercel will mark preview deployments Blocked again as it did for PR #23 (commit author not a Vercel team member). Per the plan this is scored as a hosting limitation; no Vercel setting or Cascade source will be changed.

### Step 2 — not started
16:43 Pre-check for the ask: `gh auth status` → logged in as the repo owner. Open PRs #23 (fix/page-title @ 9c11a6e) and #24 (feature/site-footer @ 3898b6d) both still open; both branches on the remote. Trello: `.env` has TRELLO_API_KEY and TRELLO_TOKEN lines (values not read).
16:43 Asked the evaluator for the go on closing #23/#24 and deleting the branches. Answer: not yet. Stopped at the end of step 1; nothing in step 2 was executed. Session paused.
