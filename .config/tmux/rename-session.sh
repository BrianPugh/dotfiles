#!/bin/sh
# Rename a freshly created tmux session after the directory it was spawned in.
# Usage: rename-session.sh <session_id> <session_name> <pane_current_path>
id="$1"
sess="$2"
path="$3"

# Only rename if session has default numeric name
case "$sess" in
  ''|*[!0-9]*) exit 0 ;;
esac

base=$(basename "$path")
if tmux rename-session -t "$id" "$base" 2>/dev/null; then
  exit 0
fi
i=1
while ! tmux rename-session -t "$id" "${base}_${i}" 2>/dev/null; do
  i=$((i+1))
  if [ "$i" -gt 100 ]; then exit 1; fi
done
