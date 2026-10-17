---
name: refactor
description: "Run the refactor workflow (structure changes, behavior provably preserved). Invoke with /refactor <what to refactor and why>."
---

# /refactor

Read `AGENTS.md` and `workflows/refactor.md`. Run the workflow for the requested refactoring.
`./scripts/check` must be green before starting. If the area lacks tests, characterization tests come first. Zero test edits — a needed test edit means behavior changed: stop and report.

