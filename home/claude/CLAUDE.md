@~/AGENTS.md

# Claude Code

- Prefer real behavior in tests when practical; use mocks or stubs only when the boundary makes them necessary.
- Protect unrelated work and avoid destructive Git operations.
- Work through recoverable blockers before asking me to intervene.
- Consider `flow-integrity-reviewer` when a branch or pull request changes a multi-step operation, asynchronous flow, partial-failure boundary, or cross-service state contract. Skip it for documentation-only or mechanical changes.
- When delegating, keep the default subagent model for work with a clear spec and a check that proves the result, and pass `effort: "high"` when that work is harder or longer. Pass `model: "opus"` for ambiguous, judgment-heavy, or long-horizon work, or when a task seems to need effort above `high`.
- When a brief asks for a change, name a check that exercises it and ask for that check's output, or for which check did not run and why; a syntax-only check or one that failed to start does not count. Ask subagents for conclusions with their evidence rather than step-by-step reasoning, and raise effort instead of urging thoroughness.
