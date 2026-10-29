#!/bin/sh
# SessionStart hook for Antigravity: inspects AGENTS.md, specs/active/, and specs/plans/ at session startup
# and injects a concise workspace status summary so the agent immediately knows the project mode and active gate.
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
cat >/dev/null 2>&1 || true

if [ ! -f "$ROOT/AGENTS.md" ]; then
  printf '{}\n'
  exit 0
fi

if grep -q "STATUS: NOT CONFIGURED" "$ROOT/AGENTS.md" 2>/dev/null; then
  msg="ANDW Workspace Status: NOT CONFIGURED. If the user wants to start a project here, recommend running /bootstrap first."
else
  mode=$(grep -m1 '^\*\*Mode:' "$ROOT/AGENTS.md" 2>/dev/null | sed 's/\*\*//g; s/^Mode:[[:space:]]*//; s/[[:space:]]*—.*//')
  lang=$(grep -m1 '^\*\*Language:' "$ROOT/AGENTS.md" 2>/dev/null | sed 's/\*\*//g; s/^Language:[[:space:]]*//; s/[[:space:]]*—.*//')
  active_specs=""
  for s in "$ROOT/specs/active/"[0-9]*.md; do
    [ -f "$s" ] || continue
    bn=$(basename "$s")
    n=$(printf '%s' "$bn" | sed 's/-.*//')
    st=$(grep -m1 '^- Status:' "$s" 2>/dev/null | sed 's/^- Status:[[:space:]]*//; s/[[:space:]]*$//')
    plan_file="$ROOT/specs/plans/$n-plan.md"
    if [ -f "$plan_file" ]; then
      app=$(grep -m1 '^- Approved by / on:' "$plan_file" 2>/dev/null | sed 's/<!--.*-->//g; s/^- Approved by \/ on:[[:space:]]*//; s/[[:space:]]*$//')
      active_specs="${active_specs}${bn} (Status: ${st:-?}, Plan Approved by/on: ${app:-none}); "
    else
      active_specs="${active_specs}${bn} (Status: ${st:-?}, no plan yet); "
    fi
  done
  [ -z "$active_specs" ] && active_specs="none"
  msg="ANDW Workspace Status — Mode: ${mode:-unset} | Language: ${lang:-unset} | Active specs: ${active_specs}. Remember to follow GEMINI.md Interactive Gate & Artifact Protocol (RequestFeedback: true + ask_question) at every gate."
fi

escaped=$(printf '%s' "$msg" | sed 's/\\/\\\\/g; s/"/\\"/g')
printf '{"injectSteps":[{"systemMessage":{"systemMessage":"%s"}}]}\n' "$escaped"
exit 0

