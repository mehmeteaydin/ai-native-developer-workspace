# ADR 0010 — First-class Antigravity (Gemini) adapter via skills, lifecycle hooks, and read-only subagent

- Status: Accepted
- Date: 2026-10-17

## Context
Developers using Google Antigravity and Gemini models (such as Gemini 4 Argon) need the same
mechanical guarantees that ANEW provides on Claude Code: slash-invocable segment commands, physical
protection of shipped specs under `specs/done/`, protection against destructive git commands, and
enforced separation between the producer session and the reviewer. Antigravity has deprecated
legacy `.agents/workflows/*.md` files in favor of `.agents/skills/<name>/SKILL.md`, supports
`PreToolUse` lifecycle hooks via `.agents/hooks.json` (using `TargetFile` and `CommandLine` in
camelCase JSON on stdin and `{"decision":"deny"}` on stdout), provides `define_subagent` with
`enable_write_tools: false`, and offers an interactive `ask_question` tool for structured human
decisions.

## Decision
Add `adapters/antigravity/` (installed via `./scripts/init antigravity` or `./scripts/init agy`) as
a thin adapter following ADR 0001 and ADR 0004:
1. **Context pointer (`GEMINI.md`):** Points to `AGENTS.md` as the single source of truth and
   instructs the agent to use `ask_question` with `(Recommended)` on the first option during
   interviews and human gates (proposal rule).
2. **Workspace skills (`.agents/skills/<name>/SKILL.md`):** All 12 core commands (`bootstrap`,
   `analyze`, `plan`, `build`, `review`, `verify`, `new-feature`, `change`, `fix-bug`, `refactor`,
   `adr`, `recover`) are exposed as progressive-disclosure skills, plus `anew-plan` as a fallback
   alias in case `/plan` collides with Antigravity's built-in `/plan` mode.
3. **Enforced independent review:** `/review` and `/new-feature` use `define_subagent`
   (`enable_write_tools: false`) + `invoke_subagent` to run `anew-reviewer` in an isolated,
   read-only subagent context.
4. **Enforced immutability and safety hooks (`.agents/hooks.json`):** `protect-shipped.sh` blocks
   modifications to `specs/done/` across file-writing tools and `run_command`; `safety-guard.sh`
   blocks `git push --force`, `git reset --hard`, `git rebase`, and `rm -rf`.
5. **Doctor & selftest parity:** `scripts/doctor` verifies that every Claude Code command has a
   matching skill in `adapters/antigravity/.agents/skills/<name>/SKILL.md` and checks hook
   permissions; `scripts/selftest` tests `scripts/init antigravity` and both hooks.

## Consequences
- Benefits: Antigravity reaches full **Enforced** parity with Claude Code on all three mechanical
  channels (context auto-loading, read-only reviewer subagent, and `PreToolUse` hooks); the core
  remains 100% tool-agnostic; `ask_question` makes interview and gate interactions structured.
- Costs: Four adapters must now stay in command parity (enforced automatically by `scripts/doctor`
  and `scripts/selftest`); Antigravity's hook JSON schema differs from Claude Code's (`TargetFile`
  and stdout JSON decision vs `file_path` and exit code 2), so hook scripts are per-adapter.

## Alternatives considered
- Forking ANEW into a Gemini-only template: rejected — breaks ADR 0001 and loses multi-tool
  compatibility.
- Packaging the adapter as `.agents/plugins/anew/plugin.json`: rejected — adds an extra nesting
  layer and requires a restart on first discovery, whereas `.agents/skills/` and `.agents/hooks.json`
  match the flat transparency of `.claude/` and `.cursor/`.
- Using legacy `.agents/workflows/*.md`: rejected — deprecated in Antigravity in favor of skills.

## Revisit triggers
- Antigravity adds declarative file-based subagent definitions under `.agents/agents/` (then
  `anew-reviewer` can move from `define_subagent` in `/review` to a static file).
- Antigravity hook payload keys or tool names change.

