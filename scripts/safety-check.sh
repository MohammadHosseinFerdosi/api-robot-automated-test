#!/usr/bin/env bash
# PreToolUse Hook — runs before every Bash command Claude executes
# Exit 2 to BLOCK execution, exit 0 to allow

COMMAND="${BASH_TOOL_COMMAND:-$*}"

# Block direct commits to main/master
if echo "$COMMAND" | grep -qE "git (push|commit).*(main|master)"; then
  echo "BLOCKED: Direct commit/push to main or master is not allowed." >&2
  echo "Create a feature branch first: git checkout -b feature/your-branch-name" >&2
  exit 2
fi

# Block running robot against production
if echo "$COMMAND" | grep -qE "robot.*production|pabot.*production"; then
  echo "BLOCKED: Running tests against production environment is not allowed." >&2
  exit 2
fi

# Block editing .env.production
if echo "$COMMAND" | grep -qE "(cat|echo|tee|sed|awk|vim|nano).*.env.production"; then
  echo "BLOCKED: Modifying .env.production is not allowed through Claude." >&2
  exit 2
fi

# Warn (but allow) if running without outputdir
if echo "$COMMAND" | grep -qE "^robot features/" && ! echo "$COMMAND" | grep -q "\-\-outputdir"; then
  echo "WARNING: Consider adding --outputdir results/ for organized output." >&2
fi

exit 0
