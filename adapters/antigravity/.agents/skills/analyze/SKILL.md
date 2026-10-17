---
name: analyze
description: "Segment ANALYZE: intent → clarify → spec → spec approval. Always stops at the handoff. Invoke with /analyze <feature>."
---

# /analyze

Read `AGENTS.md`, `docs/roles/analyst.md`, and `workflows/segments.md`. Run the ANALYZE segment for the requested feature.

Follow the segment contract exactly: entry check (no twin spec), `prompts/clarify.md` (use `ask_question` with `(Recommended)` on your proposed answer) then `prompts/spec.md`, the spec approval gate, set `Status: Approved`, write the handoff, STOP.
Never produce a plan, a plan suggestion, or code.

