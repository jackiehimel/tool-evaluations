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
