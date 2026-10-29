# GEMINI.md

All project rules live in **AGENTS.md** — single source of truth. Read it before doing anything.
Honor the operating mode it declares. Do not duplicate rules here; if this file and AGENTS.md ever
disagree, AGENTS.md wins.

## Antigravity Interactive Gate & Artifact Protocol

When running interactive interviews (clarification, bootstrap, ADR discussion) or stopping at any
human gate, always combine **Antigravity Artifacts** (`write_file` / `edit_file` in `<appDataDir>/brain/<conversation-id>/` with `ArtifactMetadata: {UserFacing: true, RequestFeedback: true}`) and **`ask_question`** (with your recommended choice first, prefixed with `(Recommended)`):

1. **Gate 1 — SPEC (`ANALYZE` → `PLAN`):**
   - Write the spec to `specs/active/<NNNN>-<name>.md` (`Status: Draft`) AND mirror it to `<artifactDir>/<NNNN>-spec.md` with `RequestFeedback: true` so the user gets an inline **Review / Proceed** card in chat.
   - Call `ask_question` with `(Recommended) Approve Spec & Proceed to PLAN — mark Status: Approved and start /plan <NNNN>` as the first option.
   - When the user clicks **Proceed** on the artifact or selects the approve option, sync any artifact edits back to `specs/active/<NNNN>-<name>.md`, set `Status: Approved`, and **automatically continue into the PLAN segment** without requiring the user to type `/plan <NNNN>` (in `strict` mode, note the role transition and offer to continue immediately or stop for a new session).
2. **Gate 2 — PLAN (`PLAN` → `BUILD`):**
   - Write the plan to `specs/plans/<NNNN>-plan.md` (`Status: Awaiting approval`) AND mirror it to `<artifactDir>/<NNNN>-plan.md` with `RequestFeedback: true`.
   - Call `ask_question` with `(Recommended) Approve Plan & Proceed to BUILD — record Approved by / on automatically and start /build <NNNN>`.
   - On approval/Proceed, automatically resolve the approver name (`git config user.name` or `$USER`) and current date (`YYYY-MM-DD`), write `Status: Approved` and `Approved by / on: <name>, <YYYY-MM-DD>` into `specs/plans/<NNNN>-plan.md`, and **automatically continue into the BUILD segment** without waiting for `/build <NNNN>`.
3. **Gate 3 — BUILD (`BUILD` → `REVIEW`):**
   - Run `./scripts/check` (full profile) and write a `<artifactDir>/<NNNN>-build-summary.md` artifact (`RequestFeedback: true`) containing the changed-file list against the plan and the real `./scripts/check` output.
   - Call `ask_question` with `(Recommended) Proceed to INDEPENDENT REVIEW — launch read-only anew-reviewer subagent`.
   - On Proceed, **automatically launch the REVIEW segment** (`define_subagent` with `enable_write_tools: false` + `invoke_subagent`).
4. **Gate 4 — REVIEW & TRIAGE (`REVIEW` → `FIX` or `VERIFY`):**
   - Save the subagent's verbatim report to `<artifactDir>/<NNNN>-review-report.md` (`RequestFeedback: true`).
   - Call `ask_question` with `(Recommended) Triage complete / Clean — proceed directly to VERIFY` (if clean) or `(Recommended) Fix all real findings (prompts/build.md §fixes), re-review, then proceed to VERIFY` (if findings exist).
   - On Proceed, execute the chosen fix/verify path automatically without requiring `/verify <NNNN>`.
5. **Gate 5 — VERIFY & SHIP (`VERIFY` → `SHIP`):**
   - Write the criterion ↔ evidence table and DoD checklist to `<artifactDir>/<NNNN>-ship-report.md` (`RequestFeedback: true`).
   - Call `ask_question` with `(Recommended) Approve & SHIP — check off DoD, fill Scorecard, set Status: Shipped, and move spec to specs/done/`.
   - On Proceed, automatically mark all DoD items `[x]`, fill the Scorecard table in the spec, set `Status: Shipped`, and move `specs/active/<NNNN>-<name>.md` to `specs/done/<NNNN>-<name>.md` (`git mv` if tracked, else `mv`), then present the final ship summary.
