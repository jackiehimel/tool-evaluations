# Scorecard — Cascade

Stock Cascade at aee88e20, worker image `cascade-worker:local` (BASELINE.md), model claude-sonnet-5 through the Claude Code engine, one evaluator, one target repo, one run per step unless stated. Capability demonstration, single run; no reliability claim. Every score below is in MATRIX.md with its evidence ID; every limitation cited is a numbered entry in FINDINGS.md.

## Coverage matrix, one line per row
| # | Stage | Score | In one sentence | Findings |
|---|---|---|---|---|
| 1 | BRD | Partly | Produces an implementation plan with scope, exclusions, assumptions and an open question, not a requirements document with acceptance criteria (E-010). | 2, 15 |
| 2 | Stories | Does it | Three traceable cards with acceptance checklists and dependency links, no human edits (E-011). | 3 |
| 3 | Architecture | Partly | Files, components and data flow before any commit; no considered alternative (E-010). | 3 |
| 4 | Coding | Partly | Six of six runs met their story checklist on a feature branch; one run edited a docs file outside the frozen scope because the approved plan told it to (E-006 to E-008, E-013, E-016, E-017). | 5, 12, 13, 14, 22 |
| 5a | Tests written | Does it (where required) | Six tests covering the three required cases on the one story that asked for tests; Not tested on the other five (E-013). | — |
| 5b | Check suite green | Does it | Six of six PRs green in CI and in local reproduction; a planted failing test was reported and repaired (E-019). | 13 |
| 6 | Review | Does it | Separate account and process, findings ranked with inline comments, a planted off-by-one caught in under three minutes and removed by the tool (E-014, E-017, E-018). | 20, 21 |
| 7a | Deploy, initiates | Blocked | No deploy stage; the hosting provider refuses previews for the tool's unverifiable commit author (E-017, D-31). | 5 |
| 7b | Deploy, observes | Partly | CI failures are reported on the PR and the card with the fix; successes and deploy results are not reported (E-019). | — |
| 8 | Smoke test | Doesn't | No agent type checks a deployed URL (E-021). | — |
| 9 | Orchestrator | Partly | Coordinates six hand-offs with cost visible per run, but human gates exist at only two, backlog feeding needs a CLI trigger per story, review is dispatched before CI, and review-to-fix has no gate and no cap (E-022). | 1, 9, 16, 17, 19, 20, 21 |
| 10 | Extensibility | Partly | A read-only agent was defined in YAML and run on demand without a fork; no scheduler exists, and the docs omit the one field a custom type needs to boot (E-023). | 7, 8, 23, 24 |

Negative controls: stage 5 passed (E-019), stage 6 passed (E-018). Two questions: what this does that the repo's CI/CD does not is the whole chain from card to reviewed PR (planning, splitting, coding, review, CI repair); export to a customer's backlog is Trello tested, Jira and Linear documentation only.

## Requirements fit (REQUIREMENTS.md)
No command line day to day: Partly. A person approves every hand-off: No as configured (gates can be added by disabling two triggers, at the cost of CLI re-triggering). Own repo and PM tool: Yes for GitHub and Trello. Cost visible: Yes. Provider switch by config: Yes with a caveat (engine flag and key also needed; finding 6). Two-person operation: Not tested. Setup time, measured: about 3 h 15 m to a first successful run.

## Cost and time observed (tool accounting, single runs)
| Item | Runs | Dollars | Tool time |
|---|---|---|---|
| Three quick stories (Phase B) | 3 | $2.45 | 4.2 min |
| Feature: planning, splitting, four backlog-manager runs, three stories through review incl. the PR #30 loop | 18 | $12.02 | 31.7 min |
| Negative controls (two, incl. the two unscored reviews of the tool's fix and the revert) | 6 | $4.00 | 25.1 min |
| Custom agent (two attempts) | 2 | $0.24 | 4.6 min |
| Evaluation total (Sep 2–3, excluding the Sep 1 first attempt) | 29 | $18.71 | 65.6 min |

Source: `runs list --json` export E-026 (per-run costUsd and durationMs; buckets by start time).

Card to PR, measured from the To Do move: 56 s, 78 s, 103 s, 76 s, 118 s, 108 s.

## Security and license (SECURITY.md, LICENSE.md; counsel to confirm)
Workers run Claude Code with permission prompts bypassed; the only limits are the capability allow-list, the push-blocking hook and the container boundary; the router holds the Docker socket (finding 11). Commits are authored by a hard-coded, unverifiable identity (finding 5). Cascade is MIT; the worker image ships Anthropic's proprietary Claude Agent SDK and one direct dependency has no license (LICENSE.md).

## Verdict: Fork
Rule applied: section 7 with D-33 (a Partly on rows 4, 9 or 10 rules out Adopt, keeps Fork eligible, and Build applies only on Doesn't).
- Adopt fails: rows 4, 9 and 10 are Partly, not Does it, and row 8 is Doesn't.
- Fork holds: rows 4, 9 and 10 are Partly (eligible under D-33); only one other stage is Doesn't (row 8) against the allowed three; the license permits modification and redistribution (MIT; counsel to confirm the SDK and the unlicensed dependency).
- Build does not apply: no row among 4, 9, 10 is Doesn't.
- Reject does not apply: the license does not block resale and every security finding is a configuration or hosting matter (SECURITY.md).
- Not Inconclusive: no early stop; no row is Not tested.

What a fork has to add or change to ship under our brand (each item traces to a finding or matrix row): a configurable committer identity (finding 5); a human gate and a round cap on review-to-fix, and a gate between stories and coding (finding 21, D-21); a review dispatch that waits for the project's CI rather than the first check suite (finding 20); backlog feeding that does not depend on the merge label, and Done mapped by default (findings 16, 17, 19); a Trello identity of its own (finding 4); a scheduler (finding 7); a deploy stage and a smoke-test agent (matrix rows 7a Deploy, initiates and 8 Smoke test); the docs fixes (findings 6, 18, 23); and the completion-check rule that forces a checklist on read-only agents (finding 24). Hosting: self-hosted Docker with a public tunnel or reverse proxy for webhooks, created by CLI (finding 10); the dashboard is a persistent server, not a static site.

## What this evaluation cannot say
Single runs, one task class, one repo, one evaluator, Cascade evaluated before OpenHands. Reliability, throughput and multi-tenant behaviour were not tested.
