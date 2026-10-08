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
