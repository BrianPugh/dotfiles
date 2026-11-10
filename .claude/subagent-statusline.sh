#!/usr/bin/env bash
# Claude Code subagent status line: one agent-panel row per subagent, with its model.
# Reads {columns, tasks[]} on stdin and writes one {"id", "content"} JSON line per row
# (https://code.claude.com/docs/en/statusline#subagent-status-lines).

jq -c '
  def tokens: if . >= 1000 then "\(. / 100 | round / 10)k" else tostring end;
  (.columns // 80) as $cols
  | .tasks[]?
  | (.model // "" | sub("^claude-"; "")) as $model
  | (.name // .agentType // "agent") as $name
  | (.tokenCount // 0 | tokens) as $tok
  # Width left for the description after the fixed parts and " · " separators.
  | ($cols - ($name | length) - ($model | length) - ($tok | length) - 9) as $room
  | (.label // .description // "") as $desc
  | (if $room < 4 then ""
     elif ($desc | length) > $room then $desc[:$room - 1] + "…"
     else $desc end) as $desc
  | {
      id,
      content: ([
        $name,
        ($desc | select(. != "")),
        ($model | select(. != "") | "\u001b[36m\(.)\u001b[0m"),
        "\u001b[2m\($tok)\u001b[0m"
      ] | join(" · "))
    }
'
