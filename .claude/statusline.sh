#!/usr/bin/env bash
# Claude Code status line: context, 5-hour session limit, and weekly limit usage.
# Reads the status-line JSON on stdin (https://code.claude.com/docs/en/statusline).

IFS=$'\x1f' read -r CTX FIVE FIVE_RESET WEEK WEEK_RESET < <(jq -r '[
  (.context_window.current_usage
    | if . then .input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens else "" end),
  (.rate_limits.five_hour.used_percentage // ""),
  (.rate_limits.five_hour.resets_at // ""),
  (.rate_limits.seven_day.used_percentage // ""),
  (.rate_limits.seven_day.resets_at // "")
] | map(tostring) | join("\u001f")')

NOW=$(date +%s)
RESET=$'\033[0m'
DIM=$'\033[2m'

# level VALUE YELLOW_AT RED_ABOVE -> ANSI color digit (1 red, 3 yellow, 2 green)
level() {
  if (( $1 > $3 )); then echo 1
  elif (( $1 >= $2 )); then echo 3
  else echo 2
  fi
}

# Time until an epoch-seconds reset, e.g. "2h14m" or "3d4h".
until_reset() {
  local s=$(( $1 - NOW ))
  (( s < 0 )) && s=0
  local d=$(( s / 86400 )) h=$(( s % 86400 / 3600 )) m=$(( s % 3600 / 60 ))
  if (( d > 0 )); then printf '%dd%dh' "$d" "$h"
  elif (( h > 0 )); then printf '%dh%02dm' "$h" "$m"
  else printf '%dm' "$m"
  fi
}

# Context tokens in use: yellow from 200k, red past 250k.
ctx_segment() {
  if [[ -z $CTX ]]; then
    printf 'ctx %s--%s' "$DIM" "$RESET"
    return
  fi
  local k=$(( CTX / 1000 ))
  printf 'ctx \033[3%dm%dk%s' "$(level "$k" 200 250)" "$k" "$RESET"
}

# Limits: yellow past 70%, red past 90%.
# pct_text PCT -> colored "NN%", or a dim "--" when absent
pct_text() {
  if [[ -z $1 ]]; then printf '%s--%s' "$DIM" "$RESET"
  else printf '\033[3%dm%d%%%s' "$(level "$1" 71 90)" "$1" "$RESET"
  fi
}

# One 10-cell bar holding both limits: each "▀" cell's top half (foreground)
# is the 5-hour fill, its bottom half (background) the weekly fill.
limits_segment() {
  local five=${FIVE%%.*} week=${WEEK%%.*}
  local f_lvl=$(level "${five:-0}" 71 90) w_lvl=$(level "${week:-0}" 71 90)
  local f_fill=$(( ${five:-0} / 10 )) w_fill=$(( ${week:-0} / 10 ))
  local empty='5;238' out="" i fg bg
  for (( i = 0; i < 10; i++ )); do
    if (( i < f_fill )); then fg=$f_lvl; else fg=8\;$empty; fi
    if (( i < w_fill )); then bg=$w_lvl; else bg=8\;$empty; fi
    out+=$'\033'"[3${fg};4${bg}m▀"
  done
  printf '5h/wk %s%s %s/%s' "$out" "$RESET" "$(pct_text "$five")" "$(pct_text "$week")"
  [[ -n $FIVE_RESET || -n $WEEK_RESET ]] && printf ' ↻%s/%s' \
    "$([[ -n $FIVE_RESET ]] && until_reset "$FIVE_RESET" || echo --)" \
    "$([[ -n $WEEK_RESET ]] && until_reset "$WEEK_RESET" || echo --)"
}

printf '%s %s│%s %s\n' "$(ctx_segment)" "$DIM" "$RESET" "$(limits_segment)"
