@~/AGENTS.md

# Claude Code

- Prefer real behavior in tests when practical; use mocks or stubs only when the boundary makes them necessary.
- Protect unrelated work and avoid destructive Git operations.
- Work through recoverable blockers before asking me to intervene.
- After I explicitly authorize review agents, consider `flow-integrity-reviewer` when a branch or pull request changes a multi-step operation, asynchronous flow, partial-failure boundary, or cross-service state contract. Skip it for documentation-only or mechanical changes, and never treat a general review request as delegation authority.
