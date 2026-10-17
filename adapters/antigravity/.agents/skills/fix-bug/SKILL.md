---
name: fix-bug
description: "Run the bug-fix workflow (reproduction before fix). Invoke with /fix-bug <what is broken, expected vs actual>."
---

# /fix-bug

Read `AGENTS.md` and `workflows/bug-fix.md`. Run the workflow for the reported bug.
Iron rule: no fix before a failing minimal reproduction test exists (R-05 pattern). Diagnose root cause before changing anything (R-01). The reproduction test is permanent. Stop at every human gate.

