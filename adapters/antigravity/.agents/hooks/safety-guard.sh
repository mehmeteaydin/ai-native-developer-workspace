#!/bin/sh
# PreToolUse hook for Antigravity:
# 1. Blocks destructive git and filesystem commands (git push --force, git reset --hard, git rebase, rm -rf) with "deny".
# 2. Auto-approves trusted project verification scripts (./scripts/check, ./scripts/doctor, ./scripts/selftest, ./scripts/init),
#    safe local git operations, and commands registered in scripts/check.conf using permissionOverrides so the agent never
#    stalls asking for manual permission on routine project checks.
# 3. Leaves unknown external commands on "ask" so the user retains control.
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
input=$(cat)
cmd=$(printf '%s' "$input" | grep -o '"CommandLine"[[:space:]]*:[[:space:]]*"[^"]*"' | head -n 1 | sed 's/.*"CommandLine"[[:space:]]*:[[:space:]]*"//; s/"$//')

# 1. Hard deny destructive commands
case " $cmd " in
  *" git push --force"*|*" git push -f "*|*" git reset --hard"*|*" git rebase"*|*" rm -rf "*)
    printf '{"decision":"deny","reason":"Blocked by ANDW safety-guard: destructive git/filesystem command (git push --force, git reset --hard, git rebase, or rm -rf) is forbidden by workspace rules."}\n'
    exit 0
    ;;
esac

# Trim leading whitespace for prefix matching
trimmed=$(printf '%s' "$cmd" | sed 's/^[[:space:]]*//')

# Helper to emit auto-approved JSON with permissionOverrides
approve() {
  escaped=$(printf '%s' "$cmd" | sed 's/\\/\\\\/g; s/"/\\"/g')
  printf '{"decision":"allow","permissionOverrides":["command(%s)"]}\n' "$escaped"
  exit 0
}

# 2a. Auto-approve core workspace scripts and safe local git / POSIX inspection commands
case "$trimmed" in
  ./scripts/check*|scripts/check*|sh\ ./scripts/check*|sh\ scripts/check*|\
  ./scripts/doctor*|scripts/doctor*|sh\ ./scripts/doctor*|sh\ scripts/doctor*|\
  ./scripts/selftest*|scripts/selftest*|sh\ ./scripts/selftest*|sh\ scripts/selftest*|\
  ./scripts/init*|scripts/init*|sh\ ./scripts/init*|sh\ scripts/init*|\
  chmod\ +x\ *scripts/*|chmod\ +x\ *.agents/hooks/*|\
  git\ status*|git\ diff*|git\ log*|git\ branch*|git\ show*|git\ rev-parse*|git\ ls-files*|\
  git\ add*|git\ commit*|git\ mv*|git\ checkout\ -b*|git\ switch\ -c*)
    approve
    ;;
esac

# 2b. Auto-approve commands configured in scripts/check.conf (if present)
if [ -f "$ROOT/scripts/check.conf" ]; then
  while IFS= read -r line; do
    case "$line" in
      ''|'#'*) continue ;;
      *:*)
        step_cmd=$(printf '%s' "${line#*:}" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
        if [ -n "$step_cmd" ] && [ "$trimmed" = "$step_cmd" ]; then
          approve
        fi
        ;;
    esac
  done < "$ROOT/scripts/check.conf"
fi

# 3. Everything else uses standard permission flow
printf '{"decision":"ask"}\n'
exit 0
