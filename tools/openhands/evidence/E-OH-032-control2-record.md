# E-OH-032 — E2b off-by-one sorting control record

Executed 2026-09-14T03:09–07:04Z under a single evaluator "go". Scoring is deliberately absent; it awaits its own `JUDGMENT REQUIRED` gate (D-OH-29).

## Pre-flight (2026-09-14T03:09Z)

- Both automations disabled, Cascade webhook inactive, PR #32 at head `05d2dfc9` (post failing-test control, tree identical to the accepted feature), control checkout clean at that head, Agent Server healthy.

## Injection

- One-line change in `lib/changelog.ts`: `.slice(1)` appended to the sorted feed, unconditionally dropping the newest entry — an off-by-one in the sort per FEATURE.md's negative-control definition. Diff preserved as E-OH-025.
- Local suite before pushing (E-OH-026): exit 1, `Tests 4 failed | 83 passed (87)`; the feature's own changelog tests catch the bug.
- Bug commit `e8ef4c3d228ccd97c917fba9e2ad411217bc0b6f` created with `git commit-tree` (evaluator-authored, identity redacted; verified free of tool-attribution trailers), pushed 2026-09-14T03:10:13Z.
- GitHub CI on the bug commit (E-OH-027): `Lint, typecheck, test, build` **failure**, completed 03:11:35Z window. Per D-OH-30 this CI result is GitHub CI evidence.

## Stock reviewer run

- The consumed `openhands-review` label was removed and re-applied at 03:11:56Z to create a fresh labeled event.
- Reviewer automation `494c00ea` enabled 03:12:30Z. Its next cron tick (03:13:08Z run) consumed the event and spawned conversation `a7228f98-d14e-405c-85d1-057947784a3a` (started 03:13:16Z, finished 03:15:04Z; 108.228 s runtime, $0.2977641, prompt 552,983 / completion 9,016 / cache read 510,618 / cache write 41,501 / reasoning 854 tokens — E-OH-029).
- Review `PRR_kwDOS00trc8AAAABNY_zxA` posted 03:14:55Z on the bug head (E-OH-028): GitHub event state COMMENTED, verdict `🔄 CHANGES REQUESTED` in body text. **The reviewer flagged the injected bug precisely**: it identified the `.slice(1)` as unconditionally discarding the newest feed entry, attached an inline comment on `lib/changelog.ts`, independently reproduced the suite failure (`4 failed / 82 passed / 1 skipped`), noted the PR description's 87/87 claim no longer held at that commit, distinguished the logic bug from type errors (`tsc` clean), and named the exact fix (remove the trailing `.slice(1)`).

## Deviation record (honesty note)

- The procedure calls for disabling the triggering automation immediately after the intended response. The review landed at 03:14:55Z, but the disable PATCH was not issued until **04:30:52Z** because the session's tool-approval flow was interrupted twice (one blocked call, one approval-card error) and then idled waiting. The automation therefore stayed enabled for ~78 minutes and recorded 54 runs in that window.
- Observed consequence: none. Only the first run spawned a conversation; the remaining 53 runs completed without conversations because the stock script had already consumed the labeled event. Exactly one review was posted; no chain formed. The automation DB run history (E-OH-018 schema) and the PR review list corroborate this.
- Separately, the bug commit remained the PR head until the revert was pushed at 07:02:51Z (same approval-flow stall). Both automations were disabled from 04:30:52Z and the webhook inactive throughout, so nothing could react to the interim head; the PR is a draft on a feature branch.

## Revert

- Revert commit `f10ae654f11008f8224d7e733735cb2eb067ce21` built directly from the pre-control tree object of `e4ca7369`; verified byte-identical. Diff preserved as E-OH-030. Attribution scan clean; evaluator-authored (redacted). Pushed 2026-09-14T07:02:51Z.
- Post-revert checks (E-OH-031): CI **success**, Vercel preview-comment success. PR #32: open, draft, 5 commits, head `f10ae654`, feature content identical to the accepted E2 tree.

## Post-control state

- Both automations disabled (reviewer disabled 04:30:52Z, verified `enabled = 0`); Cascade webhook inactive; the `openhands-review` label remains applied with its event consumed.
- Local conversation count rose only by the one reviewer conversation. No other OpenHands activity occurred.
