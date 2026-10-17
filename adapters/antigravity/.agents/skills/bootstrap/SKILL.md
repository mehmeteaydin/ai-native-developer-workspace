---
name: bootstrap
description: Adapt this workspace to your project (new or existing) through a short interview. Invoke with /bootstrap.
---

# /bootstrap

Read `AGENTS.md`, then execute `workflows/bootstrap.md` using the prompt in `prompts/bootstrap.md`.
Interview one topic at a time, always with your recommendation (proposal rule): use the `ask_question` tool and prefix your recommended choice with `(Recommended)`. Stop at every human gate.
When generating, keep the `AGENTS.md` invariant rules verbatim and the file ≤ 40 lines.
Finish by running `./scripts/doctor` and `./scripts/check`, reporting results and open decisions, and ending with the first command for the chosen mode as the prompt specifies.

