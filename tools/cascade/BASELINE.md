# BASELINE — Cascade

Recorded 2026-09-02T17:40-04:00 by the executing session (v2 plan, Phase A step 0). All values read live unless marked otherwise.

| Field | Value | Source |
|---|---|---|
| Target repo | the internal AI Garage web repo, `origin/main` = `6919f11c14d975565c6caacca1c329dc0f9f3dbe` | `git fetch origin && git rev-parse origin/main`, 2026-09-02T16:55-04:00. The evaluator's local working copy is at `3b0fab7` (behind, clean, untouched). |
| Tool | Cascade, upstream `https://github.com/mongrel-intelligence/cascade.git` | `git remote get-url origin` |
| Tool pinned commit | `aee88e203b08976a862e020df35b81f077f68ded` (2026-08-25, "fix(router): authenticate worker-image pulls against private registries (#1539)"), package version 1.0.0 | `git rev-parse HEAD`; `git status --porcelain` empty |
| Worker image | `cascade-worker:local`, Id `sha256:f8bd9ca82fb234725b68b839c85a603dc3019081ed3479d90c0407b730d8b706`, Created 2026-09-01T23:10:53Z. Built locally, never pushed: RepoDigests holds the same content hash. | `docker inspect cascade-worker:local` |
| Router image | `cascade-router:latest`, Id `sha256:53121d527bd04a8947d77b8ad9470adbc3f3f1ea6377d3eeb96cd66cb354756a`; running container uses this Id | `docker inspect cascade-router:latest`; `docker inspect cascade-router-1 --format {{.Image}}` |
| Engine binary in worker | Claude Code 2.1.185 | `docker run --rm cascade-worker:local claude --version` |
| Model id | `claude-sonnet-5` (project setting) | `projects show ai-garage` |
| Engine | unset in the project row (prints `—`); resolves to Cascade's default `claude-code` | `projects show ai-garage`; default in `src/backends/claude-code/models.ts` |
| Max in-flight items | unset (prints `—`); default 1, which counts To Do + Doing + In Review | `projects show ai-garage`; observed Sep 1 (capacity skip) |
| Base branch / branch prefix | `main` / `feature/` | `projects show ai-garage` |
| Enabled agents | `implementation` only, trigger `pm:status-changed` enabled, no parameters | `projects trigger-list ai-garage` |
| SCM integration | github, config `{}`, triggers `{}` (merge toggle off) | `projects integrations ai-garage` |
| Router config hash | `bf8838d9e80f3df80556ac0f11d1675efa29f1f5480cfb9aef9d4e52f10e864f` | sha256 of the concatenated text output of `projects show`, `projects trigger-list`, `projects integrations` for `ai-garage` (command recorded in DECISIONS.md D-4) |
| Webhooks | Trello `6a9779713a71c4e7f1e17474` → `<tunnel>/trello/webhook` active; GitHub `673360982` → `<tunnel>/github/webhook` active, events check_suite, issue_comment, pull_request, pull_request_review, pull_request_review_comment | `webhooks list ai-garage` |
| Board template | board `6a9740dea580e2eb7afd4b50`. Lists: Backlog `6a9770eb1c80929ac91f4724`, To Do `6a9740dea580e2eb7afd4b56`, Doing (mapped to inProgress) `6a9740dea580e2eb7afd4b57`, In Review `6a9770f8f644f059420c0f80`, Done `6a9740dea580e2eb7afd4b58` (not mapped). Labels: readyToProcess `6a97718cf1a279513a8aa266`, processing `6a97719558a6505e07f669c3`, processed `6a97719b51b5dcbfa964728c`, error `6a9771a06551baf32b152642`. No `auto` label key. Six additional unnamed colour labels exist on the board (template defaults), unmapped. | Ids from `projects integrations ai-garage`; board, list and label names confirmed live 2026-09-02T17:59-04:00 (E-003), board name `adlc-comparisons`, shortLink `fnx9B5yF`, not closed. |
| Credentials present in Cascade's store (masked) | GITHUB_TOKEN_IMPLEMENTER, ANTHROPIC_API_KEY, TRELLO_API_KEY, TRELLO_TOKEN | `projects credentials-list ai-garage` |
| `.env` state | `TRELLO_API_KEY=` and `TRELLO_TOKEN=` lines present but empty; Cascade uses its own credential store, where both are present and verified working (E-003); values never read | `grep -o '^TRELLO[A-Z_]*=' .env` |
