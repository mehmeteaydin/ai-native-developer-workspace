---
name: recover
description: "Something went wrong — pick and run the right recovery ramp (R-01…R-12). Invoke with /recover <what happened>."
---

# /recover

Read `prompts/recovery/README.md`. Based on what happened, identify the matching ramp (`R-01`…`R-12`), state which one and why, and after human confirmation execute its prompt from `prompts/recovery/<file>.md` exactly, including its protection rules. If nothing matches, treat it as `R-10` (ambiguity): options with costs, your recommendation, human decision.

