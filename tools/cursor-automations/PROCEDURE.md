# Cursor Automations (cloud agents) — procedure

Track B. Rules in `tools/_shared/TRACK-B-RULES.md`. Registered before any run.

**What it is.** Cursor's hosted automations: a cloud agent runs on a schedule or on GitHub/Slack/webhook/Linear events, with a prompt and optional tools, and can open PRs. Billed as cloud-agent usage. Source: cursor.com/docs/cloud-agent/automations (sources as of Oct 2026).

**Question.** Can a GitHub event in the target repo trigger a hosted agent that delivers the frozen task as a PR, with no local machine involved, and what does the run show?

**Setup.** Cursor account with cloud agents enabled; GitHub connected to the target repo. Create automations at cursor.com/automations. Run as: Me (personal account). Record the plan tier and any limits shown.

## Tests

### T-0 Setup and baseline
Record: plan, GitHub connection, repo selected, model and context setting shown. Evidence: automations page screenshot (no keys).

### T-1 Issue label to PR (stage 4 — coding)
Automation: trigger = GitHub issue label added (label `cursor-auto`); prompt = "Implement the issue as described. Open a pull request on a new branch. Do not merge."; tool = create PR; repo = target. Open an issue with the frozen Changelog feature text and add the label.
Pass = a PR opens on a non-main branch under the operator's GitHub identity, implementing the feature; checks run.
Evidence: automation config screenshot; issue URL; PR URL and diff summary; `gh pr checks` output.

### T-2 Scheduled read-only run (stage 10 — extensibility, schedule half)
Automation: trigger = schedule (one-off, a few minutes ahead); prompt = "Summarize the repository's agent registry: count agents by status and post the summary as a comment on issue #<T-1 issue>." Tools: comment on issue only; no PR tool.
Pass = the comment appears at or after the scheduled time with a correct count. Record delay.
Evidence: automation config; the comment; registry count checked by hand.

### T-3 Review on PR push (stage 6 — review)
Automation: trigger = PR pushed on the target repo; prompt = "Review the pushed changes for bugs. Comment on the PR with findings ranked by severity." Push a commit to the T-1 branch that introduces an off-by-one in the changelog sort (operator control commit).
Pass = a review comment appears that identifies the sort bug. Record whether Bugbot (managed agent) also fires if enabled.
Evidence: control commit SHA; review comment; identity of the commenter.

### T-4 Cost and usage (operational)
After T-1 to T-3, open the cloud-agent usage page. Record per-run cost if shown, otherwise the period total and the number of runs.
Evidence: usage page screenshot.

## Not tested here
Service-account runs (team admin only). Slack and Linear triggers. Webhook trigger. `Not tested`.

## After the run
Deactivate the three automations. Revert the control commit. Close the issue and PR, delete the branch. Fill `RESULTS.md`. Run the audit before confirming outcomes.
