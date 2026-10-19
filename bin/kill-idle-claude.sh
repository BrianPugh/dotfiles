#!/usr/bin/env bash
# Kill interactive `claude` sessions whose pty has been idle > 4h.
IDLE_LIMIT=$((4*60*60))          # seconds
now=$(date +%s)

ps -axo pid=,tty=,args= | awk '$3 ~ /(^|\/)claude$/ {print $1, $2}' |
while read -r pid tty; do
  [ "$tty" = "??" ] && continue          # no controlling terminal
  dev="/dev/$tty"
  [ -e "$dev" ] || continue
  at=$(stat -f %a "$dev") || continue     # pty last-access time
  idle=$(( now - at ))
  if [ "$idle" -gt "$IDLE_LIMIT" ]; then
    logger -t kill-idle-claude "killing pid $pid on $tty (idle ${idle}s)"
    kill "$pid"
  fi
done
