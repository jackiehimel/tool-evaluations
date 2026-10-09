## 9. The test feature and quick stories

Frozen before either tool runs. Acceptance checklists live in `FEATURE.md` and are not shown to the tools.

Feature prompt (stage 1 input, two paragraphs):

> Add a "Changelog" page to the site at `/changelog` that lists recent updates across all agents in the registry. Each agent's `updates[]` entries (date, author, note) should appear as one combined feed, newest first, showing the date, the agent's display name, the author and the note. Add a "Changelog" link to the portal nav. Follow the existing page and component patterns, use design tokens only, and keep the registry as the single source of truth.
>
> Include unit tests for the data function. Handle these cases: an agent with no updates, two updates on the same date (order by agent name), and an update with a missing author (show "unknown"). Dates are ISO strings; display them as YYYY-MM-DD. The page must build and pass the full check suite.

Acceptance checklist (frozen, hidden from tools): route exists; nav link present; feed sorted newest first with the tie rule; the three edge cases handled; tests exist for the data function and cover the three cases; no raw colors; no files changed outside `app/changelog/`, `lib/`, `components/portal-nav.tsx`, tests, and any `lib/*.test.ts`; full suite passes.

Expected decomposition: 3 stories, tolerance ±1. Deviation is recorded, not penalized.

Quick stories (stage 4 benchmark, one run each, from `stories/`): page title, site footer, per-route titles. Their acceptance checklists are in the story files. They count toward stage 4 only; the feature stories count toward all stages. Row 4 shows all runs and takes the lowest.

Negative controls (stage 5 and 6): after the feature PRs exist, the evaluator pushes one commit to a feature branch that introduces a failing unit test, and one that introduces an obvious bug (off-by-one in the sort). The tool must report the failing test and the reviewer must flag the bug. Both are removed afterward.


## Quick stories (from the stories/ folder, verbatim)

### story-1-trivial.md

# Story 1 — Change the AI Garage page title

**Trello card title:** Change the AI Garage page title
**Card description (paste verbatim into every tool's ticket):**

> Change the browser tab title of the AI Garage site from "AI Garage — Solvd" to "AI Garage — Solvd Agent Portal". The title is set in `app/layout.tsx` in the `metadata` export. Do not change anything else.

## Acceptance criteria
- A pull request is opened against a new branch (never `main`) by the implementer identity.
- The diff touches only `app/layout.tsx`, and only the `title` string.
- CI (lint, typecheck, test, build) is green on the PR.
- The Vercel preview deployment for the branch builds and shows the new tab title.

## Record in SCORECARD
Time card-moved → PR-opened; diff scope; CI result; preview result; manual touches needed.

### story-2-small-feature.md

# Story 2 — Add a site footer

**Trello card title:** Add a site footer with Submit and Contact links
**Card description (paste verbatim):**

> Add a footer to every page of the AI Garage site. It should appear below the page content in `app/layout.tsx` and contain two links: "Submit an idea" → `/submit` and "Contact" → `/contact`, plus the text "AI Garage · Solvd". Follow the existing component pattern (see `components/portal-nav.tsx`), use the design-system CSS variables from `app/globals.css` (`--ink`, `--rule`, `--paper`, `--accent`), and do not introduce raw colors. Run `npm run lint && npm run typecheck && npm test && npm run build` before opening the PR.

## Acceptance criteria
- PR opened against a new branch; a new `components/site-footer.tsx` (or equivalent) plus the wiring in `app/layout.tsx`; no unrelated files.
- Uses design tokens only; matches the nav's visual language.
- CI green; `npm run build` passes.
- Footer visible on the Vercel preview on at least `/`, `/library`, `/submit`.
- If the tool has a reviewer persona, it posts a review on the PR (record whether it did).

## Record in SCORECARD
Same as story 1, plus: did the agent read AGENTS.md conventions (tokens, no comments in lib, imports at top)? Did it run the checks itself?

### story-3-bug-or-refactor.md

# Story 3 — Per-route page titles

**Trello card title:** Give each page its own browser tab title
**Card description (paste verbatim):**

> Every page of the AI Garage site currently shows the same browser tab title because only the root layout sets `metadata`. Add route-level `metadata` with a `title` to these pages so the tab reads "<Page> — AI Garage": `/library` (Library), `/backlog` (Backlog), `/submit` (Submit an idea), `/roundtable` (Roundtable), `/espresso` (AI Espresso), `/contact` (Contact). Use the Next.js App Router metadata API as documented in `node_modules/next/dist/docs/` (this Next.js version differs from older ones — read the docs first, per AGENTS.md). Keep the root title as the fallback for `/`. Run the full check suite before opening the PR.

## Acceptance criteria
- PR opened against a new branch; changes limited to the six route files (or their `layout.tsx` if a page is a client component).
- Each listed route shows the correct tab title on the Vercel preview; `/` unchanged.
- CI green; build passes.
- Reviewer persona posts a review if the tool has one.

## Record in SCORECARD
Same as story 2, plus: did it handle client-component pages correctly (metadata can't be exported from `"use client"` files)?
