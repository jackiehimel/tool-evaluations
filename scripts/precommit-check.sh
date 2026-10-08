#!/bin/sh
# Run from inside the repo after `git add -A`. Exits non-zero on any scrub or secret hit in the index.
# Scrub list lives outside the repo (never committed). Override with SCRUB_LIST=/path/to/list.
cd "$(git rev-parse --show-toplevel)" || exit 2
SCRUB_LIST="${SCRUB_LIST:-$HOME/cascade-eval/scrub-list.txt}"
if [ -f "$SCRUB_LIST" ]; then
  s=$(git grep -c -i -E "$(cat "$SCRUB_LIST")" --cached 2>/dev/null | awk -F: '{n+=$NF} END{print n+0}')
else
  echo "warning: scrub list not found at $SCRUB_LIST; scrub check skipped" >&2
  s=0
fi
k=$(git grep -c -E '(sk-ant-[A-Za-z0-9_-]{20,}|sk-[A-Za-z0-9]{20,}|ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|ATTA[0-9A-Za-z]{10,})' --cached -- ':!scripts/precommit-check.sh' 2>/dev/null | awk -F: '{n+=$NF} END{print n+0}')
echo "scrub=$s secret=$k"
[ "$s" -eq 0 ] && [ "$k" -eq 0 ]
