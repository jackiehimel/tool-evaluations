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
