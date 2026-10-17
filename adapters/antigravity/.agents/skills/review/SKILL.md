---
name: review
description: "Segment REVIEW: independent, read-only review against the spec using a read-only subagent. Always stops with the report. Invoke with /review <NNNN>."
---

# /review

Read `workflows/segments.md` and run the REVIEW segment for the specified spec number (`NNNN`) or branch/diff reference. Soft entry check: build evidence (branch/diff + spec `In progress`) exists — if not, say so and ask.

You (the main session) must NEVER review the work yourself — the producer never verifies its own work (`AGENTS.md` rule 3). Instead:
1. Run `./scripts/check` (full profile) and `git diff` (or `git status`) to capture the current verification state and diff paths, or let the reviewer inspect the files directly.
2. Define a read-only reviewer subagent via `define_subagent` with:
   - `name`: `"anew-reviewer"`
   - `description`: `"Independent, read-only code reviewer for the ANEW REVIEW segment. Reviews files and diff against the spec; never writes or modifies files."`
   - `enable_write_tools`: `false`
   - `system_prompt`: `"You are the independent Reviewer defined in docs/roles/reviewer.md. Read docs/roles/reviewer.md, AGENTS.md, workflows/segments.md (REVIEW), and prompts/review.md, and follow them exactly. Review strictly from FILES (spec + plan criterion-to-test map + changed files + docs). Order findings by severity with file:line evidence and a recommended action. 'Clean' is a valid verdict."`
3. Invoke `"anew-reviewer"` via `invoke_subagent` (`Model: "inherit"`), passing the spec path in `specs/active/`, the plan path in `specs/plans/`, the list of changed files, and the latest `./scripts/check` output.
4. When the subagent returns its report, present the findings verbatim for human triage with no softening or commentary, write the handoff, STOP. Do not fix, triage, or re-review.

