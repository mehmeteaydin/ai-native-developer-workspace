---
name: new-feature
description: "Chainer: runs the full feature loop with interactive Artifact Review / Proceed buttons at every gate so you never have to type segment commands manually. Invoke with /new-feature <description>."
---

# /new-feature

Read `AGENTS.md`, `GEMINI.md`, and `workflows/segments.md` ("The chainer"). Determine the `Mode` line first.

Rule: Segments always stop at their human gates; in Antigravity, every gate presents both an **interactive Artifact** (`RequestFeedback: true` with a **Proceed** button in the side panel) and an **`ask_question` one-click approval card** so the user can review and advance through the entire loop (`ANALYZE → PLAN → BUILD → REVIEW → VERIFY → SHIP`) without typing `/plan`, `/build`, `/review`, or `/verify` by hand.

- **Mode: strict** — refuse before starting any stage. Reply in the chat language (`AGENTS.md`), command names verbatim, with this meaning:
  "Mode is strict: stages are role-owned. Analyst starts with /analyze; subsequent roles run /plan, /build, /review, /verify in their own sessions." Then stop.
- **Mode: unset** — stop; bootstrap has not run (`/bootstrap`).
- **Mode: lite** — chain `.agents/skills/analyze/SKILL.md` → `.agents/skills/plan/SKILL.md` → `.agents/skills/build/SKILL.md` → `.agents/skills/review/SKILL.md` → `.agents/skills/verify/SKILL.md` (including one-click SHIP) for the requested feature:
  - If a matching spec already exists in `specs/active/`, inspect its `Status:` and `specs/plans/<NNNN>-plan.md`'s `Approved by / on:` line, report the current state, and resume directly from the next unfinished gate — never open a twin spec.
  - At every gate (Spec, Plan, Build-to-Review, Review/Triage, Verify/Ship), create the corresponding `<artifactDir>/<NNNN>-*.md` artifact (`RequestFeedback: true`) AND call `ask_question` with `(Recommended)` on the Proceed option.
  - Whenever the user clicks **Proceed** on the artifact or chooses the recommended Proceed option, automatically sync files, record the gate metadata (`Status: Approved`, `Approved by / on: <name>, <YYYY-MM-DD>`, `Status: In progress`, `Status: Shipped`), and execute the next segment immediately.
