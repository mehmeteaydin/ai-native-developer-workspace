---
name: review
description: "Segment REVIEW: independent, read-only review via subagent → Review Report Artifact + interactive Triage/Proceed gate. Invoke with /review <NNNN>."
---

# /review

Read `AGENTS.md`, `GEMINI.md`, and `workflows/segments.md`, and run the REVIEW segment for the specified spec number (`NNNN`) or branch/diff reference. Soft entry check: build evidence (branch/diff + spec `In progress`) exists — if not, say so and ask.

You (the main session) must NEVER review the work yourself — the producer never verifies its own work (`AGENTS.md` rule 3). Instead:
1. Run `./scripts/check` (full profile) and `git status` / `git diff` to capture the current verification state and changed files.
2. Define a read-only reviewer subagent via `define_subagent` with:
   - `Name`: `"anew-reviewer"`
   - `Description`: `"Independent, read-only code reviewer for the ANEW REVIEW segment. Reviews files and diff against the spec; never writes or modifies files."`
   - `EnableWriteTools`: `false`
   - `SystemPrompt`: `"You are the independent Reviewer defined in docs/roles/reviewer.md. Read docs/roles/reviewer.md, AGENTS.md, workflows/segments.md (REVIEW), and prompts/review.md, and follow them exactly. Review strictly from FILES (spec + plan criterion-to-test map + changed files + docs). Order findings by severity with file:line evidence and a recommended action. 'Clean' is a valid verdict."`
3. Invoke `"anew-reviewer"` via `invoke_subagent` (`Model: "inherit"`, `Role: "Independent Code Reviewer"`), passing the spec path in `specs/active/`, the plan path in `specs/plans/`, the list of changed files, and the latest `./scripts/check` output.
4. **Interactive Review & Triage Gate (Artifact + One-Click Proceed):**
   - When the subagent returns its report, present the findings verbatim with no softening or commentary, and write them to `<artifactDir>/<NNNN>-review-report.md` (`ArtifactMetadata: {UserFacing: true, RequestFeedback: true, Summary: "Independent Review Report for Spec <NNNN> — click Proceed to triage / continue to VERIFY"}`).
   - Call `ask_question` with options tailored to the report:
     - If the verdict is **clean** (zero findings):
       - `(Recommended) Review is clean — Proceed directly to VERIFY (/verify <NNNN>)`
       - `Stop here — I will run /verify <NNNN> later`
     - If **findings exist**:
       - `(Recommended) Fix all real findings now (prompts/build.md §fixes), re-run independent review, then proceed to VERIFY`
       - `Proceed directly to VERIFY (treat findings as noise — I will note rationale)`
       - `Custom triage — I will specify which findings are real, noise, or investigate`
5. **Auto-Transition on Proceed:**
   - If the user clicks **Proceed** on a clean review or selects **Proceed directly to VERIFY**, **immediately execute the VERIFY segment** (`.agents/skills/verify/SKILL.md`) for `<NNNN>`.
   - If the user selects **Fix all real findings now**, execute `prompts/build.md` §fixes, re-invoke `anew-reviewer` on the fix diff, and once clean, proceed into VERIFY.
