#!/bin/sh
# PreToolUse hook for Antigravity: files under specs/done/ are immutable (AGENTS.md invariant rule 7).
# Reads the toolCall JSON from stdin and outputs {"decision":"deny",...} if targeting specs/done/.
input=$(cat)

# Check Path / TargetFile (used by write_file, edit_file, write_to_file, replace_file_content, multi_replace_file_content)
path=$(printf '%s' "$input" | grep -oE '"(Path|TargetFile)"[[:space:]]*:[[:space:]]*"[^"]*"' | head -n 1 | sed -E 's/.*"(Path|TargetFile)"[[:space:]]*:[[:space:]]*"//; s/"$//')
case "$path" in
  *specs/done/*)
    printf '{"decision":"deny","reason":"Blocked: specs/done/ is immutable (shipped specs are the historical record — AGENTS.md rule 7). Behavior changing? Open a NEW spec in specs/active/ referencing the old one."}\n'
    exit 0
    ;;
esac

# Check CommandLine (used by run_command) for write/delete/move operations targeting specs/done/
cmd=$(printf '%s' "$input" | grep -o '"CommandLine"[[:space:]]*:[[:space:]]*"[^"]*"' | head -n 1 | sed 's/.*"CommandLine"[[:space:]]*:[[:space:]]*"//; s/"$//')
case "$cmd" in
  *specs/done/*)
    case "$cmd" in
      *rm\ *|*cp\ *|*sed\ -i*|*tee\ *|*"> "*|*">>"*)
        printf '{"decision":"deny","reason":"Blocked: specs/done/ is immutable (AGENTS.md rule 7). Never modify or delete shipped specs via shell commands."}\n'
        exit 0
        ;;
      *mv\ *)
        # Allow moving a newly shipped spec FROM specs/active/ INTO specs/done/, but deny moving/renaming an existing file OUT OF or WITHIN specs/done/
        case "$cmd" in
          *specs/active/*specs/done/*) ;;
          *)
            printf '{"decision":"deny","reason":"Blocked: specs/done/ is immutable (AGENTS.md rule 7). Existing shipped specs cannot be moved or renamed."}\n'
            exit 0
            ;;
        esac
        ;;
    esac
    ;;
esac

printf '{"decision":"allow"}\n'
exit 0
