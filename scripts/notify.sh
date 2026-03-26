#!/bin/bash
# Claude Code notification hook script
# Reads hook JSON from stdin, shows macOS notification with branch + message

input=$(cat)
message=$(echo "$input" | python3 -c "import sys,json; print(json.load(sys.stdin).get('message','Needs your attention'))" 2>/dev/null || echo "Needs your attention")
branch=$(git -C "$PWD" branch --show-current 2>/dev/null || echo "unknown")

osascript -e "display notification \"[$branch] $message\" with title \"Claude Code\" sound name \"Ping\""
