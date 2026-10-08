# E-010 — Phase C step 8, planning run on the feature card (single run)

Companion file: `E-010-feature-card-after-planning.json` (full card export: description, checklist, comments, move actions).

## Timeline (UTC)
| Event | Time |
|---|---|
| Feature card created in Backlog | 2026-09-03T01:43:29Z (description fixed 01:44:02Z) |
| Gate action: drag to Planning; passed through To Do (implementation trigger skipped at capacity), Doing, In Review | 01:45:04.884Z → 01:45:11.566Z |
| Router: trigger matched, coalesced job | 01:45:11.884Z / .895Z |
| Progress comment "🗺️ Planning implementation" | 01:45:23.250Z (later edited to "📋 Implementation Plan Ready") |
| Run started | 01:45:24.291Z |
| Card description replaced with the plan (8,133 chars); checklist "📋 Implementation Steps" (6 items) added | 01:47:31.984Z |
| Run completed | 01:47:59.092Z |
| Worker exited | 01:47:59.755Z |

Run ca78834e-3d5a-4cee-a503-7f3eb973517b · planning · claude-code · claude-sonnet-5 · completed · **154.8 s · $1.160684** · 46 LLM calls (1,951,359 input of which 1,744,413 cached; 288 output) · tool calls: Read ×17, Bash ×14 (no Write/Edit; no PR). Card stayed in Planning, label `processed`. No commit exists yet, so the plan's timestamp precedes the first commit.

## What the plan contains (against the row 1 and row 3 criteria)
Row 1 (BRD: scope, exclusions, assumptions, acceptance criteria, open questions):
- Scope: yes — TLDR lists the data function, page, nav link; "Scope note" defines "all agents" as `backlogAgents`.
- Exclusions: yes — shipped/library agents have no `updates[]` and are out of scope; docs and validation changes to add them are named as a separate follow-up.
- Assumptions: yes — author is required by the current schema so the "unknown" fallback is defensive; dates may be `YYYY-MM-DD` or full ISO.
- Acceptance criteria: **not as a section**. A "Testing Strategy" lists the checks (unit, typecheck, lint, build, manual) and a manual spot-check list; there is no user-facing acceptance list.
- Open questions: yes — "flagging this as an open question" on shipped-agent updates.
Row 3 (Architecture: files, components, data flow, at least one considered alternative, consistent with repo conventions, before any code):
- Files: yes — `lib/changelog.ts`, `tests/changelog.test.ts`, `app/changelog/page.tsx`, `lib/garage-content.ts`, `docs/architecture.md`, each with what changes.
- Components and data flow: yes — registry `backlogAgents` → `buildChangelogFeed(ChangelogSource[])` → `listChangelogEntries()` → server page; nav derived from `navGroups`; sort rule and date normalisation stated.
- Considered alternative: **none stated**. Choices are made (decoupled `ChangelogSource` for testability; nav via content file rather than the component) but no alternative is presented and rejected.
- Repo conventions: yes — cites the existing Updates block, test style, page chrome classes, tokens.
- Before code: yes.

## Items carried forward
- Step 5 of the plan edits `docs/architecture.md`. FEATURE.md's frozen scope for row 4 allows `app/changelog/`, `lib/`, `components/portal-nav.tsx`, tests and `lib/*.test.ts` only. If the tool follows its own plan, the docs change will fail the changed-files audit (Partly on row 4 for that story) unless the evaluator edits the plan first (corrective work, counted). The nav change via `lib/garage-content.ts` is inside `lib/`, so allowed.
- The plan puts tests under `tests/changelog.test.ts` (repo convention) rather than `lib/*.test.ts`; FEATURE.md allows "tests", so allowed.
- The agent's comment ends "move to TODO when ready to implement", which would bypass splitting. Row 9 note: the tool does not steer the card toward the next lifecycle stage.
