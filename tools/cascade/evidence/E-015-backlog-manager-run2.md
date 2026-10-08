# E-015 — Phase C step 9, backlog-manager second on-demand run (Backlog Blocked)

Trigger: `runs trigger --project ai-garage --agent-type backlog-manager` at 2026-09-03T03:04:14Z, after the evaluator moved the story 1 card In Review → Done at 03:03:03Z (gate action; the pipeline limit counts In Review).

Run efabc9a8 · backlog-manager · **33.9 s · $0.278588** · triggerType manual · success true.

Outcome at 03:04:42Z: comment "**Backlog Blocked**" on the page-story card:
> All cards in the backlog appear to have dependencies:
> - /changelog page: Blocked by "combined changelog data feed" — this dependency card was not found in TODO, IN PROGRESS, IN REVIEW, DONE, or MERGED, so it cannot be confirmed as complete.
> - Changelog linked in nav and docs: Waiting for both the data feed story and the /changelog page story, neither of which is confirmed merged.
> Manual intervention may be needed to unblock the backlog.

No card moved. Board after: two stories in Backlog (no labels), parent in Splitting (processed), story 1 in Done (processed), quick stories in Done.

Cause: the board's Done list (`6a9740dea580e2eb7afd4b58`) is not in the PM mapping, so a card there is outside the pipeline snapshot. `done` and `merged` are optional mapping keys (`src/pm/lifecycle.ts:33-34`). Finding 19.

Observation for row 9: the dependency check itself worked as designed — it read the "🔗 Dependencies" checklists the splitter wrote, followed the links, and refused to start a story whose prerequisite it could not confirm. It also posted the block reason on the first blocked card, as its prompt says.
