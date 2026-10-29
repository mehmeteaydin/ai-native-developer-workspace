---
name: verify
description: "Segment VERIFY: acceptance criteria ↔ evidence table (QA) → interactive Ship Artifact + one-click SHIP completion. Invoke with /verify <NNNN>."
---

# /verify

Read `AGENTS.md`, `GEMINI.md`, `docs/roles/qa.md`, and `workflows/segments.md`. Run the VERIFY segment for the specified spec number (`NNNN`). Soft entry check: triage is complete — if no review/triage record exists, say so and ask.

1. **Execute Verification:** Use `prompts/verify.md`: run `./scripts/check` (full profile — never `--fast`) to capture real output and produce the criterion ↔ evidence table. A claim without evidence is a gap, and gaps are findings. Do not write or modify any production code.
2. **Interactive Ship Gate (Artifact + One-Click Proceed):**
   - Write the verification table, full `./scripts/check` proof, and Definition of Done checklist to `<artifactDir>/<NNNN>-ship-report.md` (`ArtifactMetadata: {UserFacing: true, RequestFeedback: true, Summary: "QA Verification & Ship Report for Spec <NNNN> — click Proceed to SHIP and archive spec to specs/done/"}`).
   - Call `ask_question` with:
     - `(Recommended) Approve & SHIP Spec <NNNN> — check off DoD, fill Scorecard, set Status: Shipped, and move spec to specs/done/`
     - `Keep in specs/active/ for now — stop with the verification table`
3. **Auto-Ship on Proceed:**
   - When the user clicks **Proceed** on the ship artifact or selects **Approve & SHIP Spec <NNNN>**:
     1. In `specs/active/<NNNN>-<name>.md`, set `- Status: Shipped`, mark all Definition of Done checkboxes `- [x]`, and fill the `## Scorecard` table with the actual metrics from this cycle (spec revisions, fix rounds, real/noise findings, regressions).
     2. Move the spec file from `specs/active/<NNNN>-<name>.md` to `specs/done/<NNNN>-<name>.md` (use `git mv` if tracked by git, otherwise `mv`) — note that once in `specs/done/`, `protect-shipped.sh` locks it as immutable.
     3. Run `./scripts/doctor` to confirm workspace health and present the final Ship Summary ready for commit/PR.
