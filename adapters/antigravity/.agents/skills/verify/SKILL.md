---
name: verify
description: "Segment VERIFY: acceptance criteria against concrete evidence (QA). Always stops with the table. Invoke with /verify <NNNN>."
---

# /verify

Read `AGENTS.md`, `docs/roles/qa.md`, and `workflows/segments.md`. Run the VERIFY segment for the specified spec number (`NNNN`). Soft entry check: triage is complete — if no review/triage record exists, say so and ask.

Use `prompts/verify.md`: run tests to capture real output (`./scripts/check` full profile) and produce the criterion ↔ evidence table; a claim without evidence is a gap, and gaps are findings. Do not write or modify any production code. Write the handoff, STOP. Do not ship, merge, or move files.

