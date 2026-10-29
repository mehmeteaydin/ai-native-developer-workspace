---
name: build
description: "Segment BUILD: implement the approved plan → scripts/check green → interactive Build Summary Artifact + Proceed to REVIEW. Invoke with /build <NNNN>."
---

# /build

Read `AGENTS.md`, `GEMINI.md`, `docs/roles/developer.md`, and `workflows/segments.md`. Run the BUILD segment for the specified spec number (`NNNN`).

1. **Entry check:** Refuse with the segment's exact message unless `specs/plans/<NNNN>-plan.md` has a filled `Approved by / on` line.
2. **Execute Build:** Set `specs/active/<NNNN>-*.md` to `- Status: In progress` (or resume if it already is), then execute `prompts/build.md`. Iterate with `./scripts/check --fast` and finish with a full `./scripts/check` run. Never review your own build.
3. **Interactive Build-to-Review Gate (Artifact + One-Click Proceed):**
   - Write a build summary artifact to `<artifactDir>/<NNNN>-build-summary.md` (`ArtifactMetadata: {UserFacing: true, RequestFeedback: true, Summary: "Build <NNNN> complete (scripts/check green) — click Proceed to run Independent Review"}`) containing the changed-file list compared against `specs/plans/<NNNN>-plan.md` and the real full `./scripts/check` output.
   - Call `ask_question` with:
     - `(Recommended) Proceed to INDEPENDENT REVIEW — launch read-only anew-reviewer subagent now`
     - `Stop here — I will run /review <NNNN> later`
4. **Auto-Transition on Proceed:**
   - When the user clicks **Proceed** on the artifact or selects **Proceed to INDEPENDENT REVIEW**, **immediately execute the REVIEW segment** (`.agents/skills/review/SKILL.md`) for `<NNNN>` without waiting for `/review <NNNN>`.
