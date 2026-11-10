@~/AGENTS.md

# Claude Code

- Prefer real behavior in tests when practical; use mocks or stubs only when the boundary makes them necessary.
- Protect unrelated work and avoid destructive Git operations.
- Work through recoverable blockers before asking me to intervene.
- Consider `flow-integrity-reviewer` when a branch or pull request changes a multi-step operation, asynchronous flow, partial-failure boundary, or cross-service state contract. Skip it for documentation-only or mechanical changes.
- Delegate bounded implementation across several files, or independent workstreams, to the matching specialist; do single-file edits and steps that depend on your current context directly.
- Run specialist subagents on Opus at `xhigh` effort. My specialist definitions set both, so pass no `model` or `effort` that lowers them; for a specialist whose definition sets neither, such as a project's own, pass `model: "opus"` and `effort: "xhigh"`.
- Run every other subagent on Opus at `high` effort: Opus is the default subagent model, so pass `effort: "high"` and no `model`. Never select Sonnet for a subagent, teammate, or workflow agent.
- When a brief asks for a change, name a check that exercises it and ask for that check's output, or for which check did not run and why; a syntax-only check or one that failed to start does not count. Check that evidence before accepting the result. Ask subagents for conclusions with their evidence rather than step-by-step reasoning, and raise effort instead of urging thoroughness.
