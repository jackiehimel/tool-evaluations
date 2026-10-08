# Frozen feature task — Changelog page

Target repository: the AI Garage web app (Next.js). Same task used for every Track A run since September 2026 so results stay comparable. Paste the two paragraphs below as the work item, verbatim.

> Add a "Changelog" page to the site at `/changelog` that lists recent updates across all agents in the registry. Each agent's `updates[]` entries (date, author, note) should appear as one combined feed, newest first, showing the date, the agent's display name, the author and the note. Add a "Changelog" link to the portal nav. Follow the existing page and component patterns, use design tokens only, and keep the registry as the single source of truth.
>
> Include unit tests for the data function. Handle these cases: an agent with no updates, two updates on the same date (order by agent name), and an update with a missing author (show "unknown"). Dates are ISO strings; display them as YYYY-MM-DD. The page must build and pass the full check suite.

Acceptance is checked against the visible behavior above only. Each tool's PROCEDURE.md registers what is verified before the run. No hidden requirements (METHODOLOGY.md section 4).
