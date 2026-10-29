---
name: analyze
description: "Segment ANALYZE: intent → clarify → spec → interactive spec approval gate (Artifact + Proceed button). Automatically transitions to PLAN on approval. Invoke with /analyze <feature>."
---

# /analyze

Read `AGENTS.md`, `GEMINI.md`, `docs/roles/analyst.md`, and `workflows/segments.md`. Run the ANALYZE segment for the requested feature.

1. **Entry check:** Confirm no twin spec exists in `specs/active/` (if one matches, offer to resume it from its current gate).
2. **Clarify & Draft:** Execute `prompts/clarify.md` (use `ask_question` with `(Recommended)` on your proposed answer) then `prompts/spec.md` (including the self-critique pass) to create `specs/active/<NNNN>-<name>.md` with `Status: Draft`.
3. **Interactive Spec Gate (Artifact + One-Click Proceed):**
   - Also write a user-facing artifact copy to `<artifactDir>/<NNNN>-spec.md` using `write_file` with `ArtifactMetadata: {UserFacing: true, RequestFeedback: true, Summary: "Spec <NNNN> ready for review and approval"}` so the user gets an inline **Review / Proceed** button in chat, plus a clickable `[specs/active/<NNNN>-<name>.md](file://...)` link.
   - Immediately call `ask_question` with:
     - `(Recommended) Approve Spec & Proceed to PLAN — set Status: Approved and generate the implementation plan now`
     - `Approve Spec & Stop here — set Status: Approved and end this session (strict role handoff)`
     - `Request changes — I will describe what to revise in the spec`
4. **Auto-Transition on Proceed:**
   - If the user clicks **Proceed** on the artifact or selects **Approve Spec & Proceed to PLAN**, sync any user edits from the artifact back into `specs/active/<NNNN>-<name>.md`, update `- Status: Approved` in `specs/active/<NNNN>-<name>.md`, and **immediately execute the PLAN segment** (`.agents/skills/plan/SKILL.md`) for `<NNNN>` in the same turn without making the user type `/plan <NNNN>`.
   - If the user selects **Approve Spec & Stop here**, update `- Status: Approved`, write the handoff `"Next: PLAN — Developer runs /plan <NNNN>"`, and STOP.
