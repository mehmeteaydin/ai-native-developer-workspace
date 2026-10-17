---
name: plan
description: "Segment PLAN: plan from an Approved spec → approval recorded in the plan. Always stops. Invoke with /plan <NNNN> (or /anew-plan <NNNN>)."
---

# /plan

Read `AGENTS.md`, `docs/roles/developer.md`, and `workflows/segments.md`. Run the PLAN segment for the specified spec number (`NNNN`).

Entry check first: refuse with the segment's exact message unless `specs/active/<NNNN>-*.md` says `Status: Approved`. Then run `prompts/plan.md`, stop at the plan approval gate (use `ask_question` with `(Recommended)` when presenting choices), record `Approved by / on: <name>, <date>` in `specs/plans/<NNNN>-plan.md`, write the handoff, STOP.
Write no code; never start the build.

