---
name: anew-plan
description: "Alias for /plan when the built-in /plan slash command is active. Segment PLAN: plan from an Approved spec → interactive plan approval gate (Artifact + Proceed button)."
---

# /anew-plan

Read `AGENTS.md`, `GEMINI.md`, `docs/roles/developer.md`, and `workflows/segments.md`. Run the PLAN segment for the specified spec number (`NNNN`) exactly as defined in `.agents/skills/plan/SKILL.md`:

1. **Entry check:** Refuse with the segment's exact message unless `specs/active/<NNNN>-*.md` says `Status: Approved` (or `In progress` when revising).
2. **Draft the Plan:** Execute `prompts/plan.md` and write `specs/plans/<NNNN>-plan.md` with `- Status: Awaiting approval` and `- Approved by / on: —`. Write no application code.
3. **Interactive Plan Gate (Artifact + One-Click Proceed):**
   - Mirror the plan to `<artifactDir>/<NNNN>-plan.md` using `write_file` with `ArtifactMetadata: {UserFacing: true, RequestFeedback: true, Summary: "Implementation Plan <NNNN> — click Proceed to approve and start BUILD"}`.
   - Resolve the default approver identity (`git config user.name` or `$USER`) and current date (`YYYY-MM-DD`).
   - Call `ask_question` with:
     - `(Recommended) Approve Plan & Proceed to BUILD — record "<name>, <YYYY-MM-DD>" in specs/plans/<NNNN>-plan.md and start building now`
     - `Approve Plan & Stop here — record "<name>, <YYYY-MM-DD>" and stop before BUILD`
     - `Revise Plan — I have feedback on the steps, blast radius, or test map`
4. **Auto-Transition on Proceed:**
   - When the user clicks **Proceed** on the plan artifact or selects **Approve Plan & Proceed to BUILD**, sync any artifact edits to `specs/plans/<NNNN>-plan.md`, set `- Status: Approved` and `- Approved by / on: <name>, <YYYY-MM-DD>` in `specs/plans/<NNNN>-plan.md`, and **immediately execute the BUILD segment** (`.agents/skills/build/SKILL.md`) for `<NNNN>` without requiring the user to type `/build <NNNN>`.
