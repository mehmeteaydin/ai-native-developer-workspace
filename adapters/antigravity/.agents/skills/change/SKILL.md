---
name: change
description: "Change request: triage (bug / trivial / change), then runs the lane with interactive Artifact Review / Proceed gates. Invoke with /change <request and work item>."
---

# /change

Read `AGENTS.md`, `GEMINI.md`, `workflows/change-request.md`, and `workflows/segments.md`. Handle the requested change:

1. **TRIAGE.** Apply the three-question rubric in `workflows/change-request.md`, in its order, as written. Present the verdict (`BUG` / `TRIVIAL` / `CHANGE`) WITH your rationale (proposal rule, using `ask_question` with `(Recommended)`) and wait for confirmation. Read the trivial-change policy from `docs/git.md` ("Trivial changes") first.
2. **BUG** → say so, offer via `ask_question` to immediately launch `/fix-bug` with the report, or stop.
3. **TRIVIAL** → restate the policy from `docs/git.md`, then run the trivial lane: one narrow commit, `./scripts/check` green, PR/reviewer as the policy says. If it needs a second file or a new test, stop and re-triage.
4. **CHANGE** → twin check first: if a spec in `specs/active/` carries the same `Source:` key, show it and ask whether to resume it from its current gate — never open a second one. Then run the mini-spec lane (`specs/TEMPLATE-mini.md`: `Source:` mandatory, changed + preserved criteria, `Supersedes:` if a shipped spec exists) using the **Antigravity Interactive Gate & Artifact Protocol** (`GEMINI.md`):
   - Mirror the mini-spec, plan, build summary, review report, and verify/ship report to `<artifactDir>/<NNNN>-*.md` with `RequestFeedback: true` and present `ask_question` with `(Recommended) Approve & Proceed` at each gate so the user can click **Proceed** to flow through `ANALYZE (mini) → PLAN → BUILD → REVIEW → VERIFY → SHIP` without typing slash commands manually (in `strict` mode, include the option to stop at the role boundary).
