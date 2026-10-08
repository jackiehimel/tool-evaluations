# E-011 — Phase C step 8, splitting run on the feature card (single run)

Companion: `E-011-story-cards-after-splitting.json` (full export of the three story cards and the parent: descriptions, checklists, creation times, actions).

## Timeline (UTC)
| Event | Time |
|---|---|
| Gate action: story 3 card In Review → Done (frees the slot) | 02:00:26.628Z |
| Gate action: feature card Planning → Splitting, dropped directly | 02:00:32.637Z |
| Router: trigger matched / coalesced job | 02:00:32.988Z / .999Z |
| Run started | 02:00:45.310Z |
| Story card 1 created in Backlog | 02:01:15.991Z |
| Story card 2 created in Backlog | 02:01:32.810Z |
| Story card 3 created in Backlog | 02:01:47.493Z |
| Run completed | 02:02:34.310Z |
| Worker exited | 02:02:35.257Z |
| Auto-chain to backlog-manager | did not fire (see below) |

Run 43ec5dc6 · splitting · claude-code · claude-sonnet-5 · completed · **109.0 s · $0.706883** · 28 LLM calls (966,597 input of which 856,593 cached; 214 output) · tool calls: Bash ×20 (card creation via the tool's own CLI gadgets). Parent card stays in Splitting, label `processed`, description untouched (as the splitting prompt requires).

## Stories produced (count 3; plan expected 3 ± 1)
| # | Card | Title | Acceptance items | Dependencies declared | Out of scope stated |
|---|---|---|---|---|---|
| 1 | 6a98d4eb… | As a visitor, I want a combined changelog data feed so that agent update history can be surfaced consistently | 7 | none | page, nav/docs, shipped-agent updates |
| 2 | 6a98d4fc… | As a visitor, I want a /changelog page so that I can browse all agent updates in one place | 7 | story 1 | nav, docs, data function |
| 3 | 6a98d50b… | As a visitor, I want the Changelog linked in nav and docs so that I can discover it | 6 | stories 1 and 2 | portal-nav.tsx edits, page, data function |

Each card: TLDR, technical notes with exact files, types, function behaviour and commands, an out-of-scope section, and a "✅ Acceptance Criteria" checklist. Cards 2 and 3 carry a "🔗 Dependencies" checklist linking the prerequisite cards. No comments on the story cards.

## Traceability to the section 9 prompt
- `/changelog` page listing updates across agents, newest first, showing date, agent display name, author, note → story 2 (markup lists date · agent link · author, then note) with the ordering in story 1.
- "Changelog" link in the portal nav → story 3 (via `lib/garage-content.ts` `navGroups`, which the nav component reads).
- Existing patterns, design tokens only, registry as single source of truth → stories 1 and 2 (mirrors the existing Updates block; tokens only; reads `backlogAgents`).
- Unit tests for the data function with the three cases (no updates; same date ordered by agent name; missing author → "unknown") → story 1 acceptance item 6 names all three plus ISO truncation and overall ordering.
- ISO dates shown as YYYY-MM-DD → story 1 (`slice(0, 10)`).
- Build and full check suite → every story's last acceptance item.
- Not in the prompt but carried from the plan: story 3 also edits `docs/architecture.md` — outside the frozen row 4 scope (same item as E-010).
- Independence: the cards are separable and each claims to be valuable alone, but they form a declared chain (2 needs 1 merged; 3 needs 1 and 2). The splitting prompt is designed to produce ordered stories.

## Why auto-chain did not fire
`src/triggers/shared/splitting-auto-chain.ts:36-41`: the chain returns early, without logging, unless the parent card carries the `auto` label and the PM mapping has `labels.auto`. The same label gates auto-merge in `src/triggers/github/pr-ready-to-merge.ts:215`. The evaluation's preflight (plan step 4) requires no `auto` key, so backlog-manager cannot be exercised without also enabling the tool's automatic-merge path. The `internal:auto-chain` trigger being enabled (D-21) was necessary but not sufficient.
