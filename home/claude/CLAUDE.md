@~/AGENTS.md

# Claude Code

## Working Style

- Inspect the repository and relevant runtime evidence before acting.
- Prefer files, searches, diffs, logs, tests, and command output over intuition.
- For implementation requests, complete the authorized change and verify the outcome end to end.
- Prefer real behavior in tests when practical. Use mocks or stubs only when the boundary makes them necessary.
- Protect unrelated work and avoid destructive Git operations.
- State material assumptions and uncertainty explicitly.
- Keep responses concise and focused on the technical outcome.
- Work through recoverable blockers before asking the user to intervene.

## Pull Requests

- Keep pull request descriptions natural, concise, and outcome-focused. Follow the repository template when one exists.
- When reviewing a branch or pull request, include the `flow-integrity-reviewer` agent. It traces operations across boundaries and checks return-value and asynchronous-flow contracts.
