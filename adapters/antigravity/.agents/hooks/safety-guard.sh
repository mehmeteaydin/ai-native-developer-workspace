#!/bin/sh
# PreToolUse hook for Antigravity: blocks destructive git and filesystem commands (docs/git.md, AGENTS.md).
# Reads the toolCall JSON from stdin and outputs {"decision":"deny",...} on dangerous commands.
input=$(cat)
cmd=$(printf '%s' "$input" | grep -o '"CommandLine"[[:space:]]*:[[:space:]]*"[^"]*"' | head -n 1 | sed 's/.*"CommandLine"[[:space:]]*:[[:space:]]*"//; s/"$//')

case " $cmd " in
  *" git push --force"*|*" git push -f "*|*" git reset --hard"*|*" git rebase"*|*" rm -rf "*)
    printf '{"decision":"deny","reason":"Blocked by ANEW safety-guard: destructive git/filesystem command (git push --force, git reset --hard, git rebase, or rm -rf) is forbidden by workspace rules."}\n'
    exit 0
    ;;
esac

printf '{"decision":"allow"}\n'
exit 0

