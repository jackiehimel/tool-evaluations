# E-013 — Phase C step 9, feature story 1 (data feed), implementation run and review attempt

## Timeline (UTC)
| Event | Time |
|---|---|
| Card Backlog → To Do by backlog-manager (E-012) | 02:33:35.220Z |
| Implementation trigger matched / coalesced job | 02:33:35.482Z / .684Z |
| Progress comment; card To Do → Doing | 02:33:47.013Z / 02:33:48.478Z |
| Run started | 02:33:48.656Z |
| PR #28 opened | 02:34:51Z |
| Vercel deployment Blocked (bot author) | ≈02:34:55Z |
| Router: `check-suite-success` handler (Vercel check suite) → **HttpError 403 "Resource not accessible by personal access token"** on `GET /repos/…/actions/runs?head_sha=…` | 02:34:57.810Z |
| Run completed | 02:35:22.256Z |
| Worker exited | 02:35:25.214Z |
| GitHub Actions "Lint, typecheck, test, build" SUCCESS | 02:35:59Z |
| Router: `check-suite-success` handler (Actions check suite) → same 403 | 02:36:02.304Z |
| Review dispatched | **none** |

**Card → PR: 76 s** (from the tool's own move). Run 3c5f1cce · implementation · claude-code · claude-sonnet-5 · **93.6 s · $0.774754** · success true.

## PR #28
- Branch `feature/changelog-data-feed` → `main`, commit 9636257c authored Cascade Bot, merge-base == origin/main.
- Files (+127 −0): `lib/changelog.ts` (+32) — `ChangelogEntry`, `ChangelogSource`, `buildChangelogFeed`, `listChangelogEntries`, date `slice(0,10)`, author fallback `"unknown"`, sort newest-first then agent title; `tests/changelog.test.ts` (+95) — six cases: no updates → zero entries; same-date tie-break by title; blank/whitespace author → "unknown"; newest-first across three agents; ISO timestamp truncation; id/title pass-through.
- Story acceptance checklist (card): all seven items satisfied by the diff (types and functions exported; flatten with pass-through; date normalisation; author fallback; sort with tie-break; the named test cases; suite green).
- Frozen scope (FEATURE.md): `lib/` and tests only ✔. Unrequested changes: none. Corrective work: 0.
- Feature prompt's three required test cases (no updates; same date ordered by agent name; missing author → "unknown") are all present in the test file — the first time row 5a's "adds tests for the change" is exercised.
- PR body: Summary + Test plan claiming test (85), typecheck, lint on changed files; does not claim build.

## Check suite
- CI SUCCESS 02:35:59Z. Local reproduction on 9636257 (02:35:52Z → 02:36:07Z): npm ci OK, lint 0, typecheck 0, **test 85/85 (79 + 6 new)**, build 0. Worktree removed.

## Review (row 6) — not dispatched
- Both `check_suite` completions (Vercel at 02:34:56Z, Actions at 02:36:01Z) matched the enabled `review` trigger; the handler then calls `client.actions.listWorkflowRunsForRepo` (`src/github/client.ts:386`) with the implementer token and got 403. The implementer token is a fine-grained PAT without the Actions read permission (an evaluation setup choice recorded on Sep 1; the appendix notes the same 403 on check-run reads).
- The worker-side post-completion review path (`src/triggers/shared/post-completion-review.ts:35`, `getCheckSuiteStatus`) needs the same API; no review dispatch line appears in the run log and no review run exists.
- Docs: `docs/getting-started.md:120` asks for tokens "with `repo` scope" (classic), or "fine-grained tokens", without listing the fine-grained permissions needed; classic `repo` includes Actions read, fine-grained does not by default. Attribution: shared — evaluator token choice plus a documentation gap.
