# AGENTS.md

Managed by Home Manager from `~/.config/home-manager/home/AGENTS.md`. Personal agent-harness and declarative environment changes belong in `~/.config/home-manager`, never in generated files under `$HOME`; project-specific harness changes belong in their project repository.

## Workflow

- don't post comments to GitHub without my authorization
- do not send messages, emails, SMS, or any other outbound communication without my authorization
- no need to use `git -C` if you are already in the project directory
- avoid using `--` when writing text so it keeps a natural tone
- before committing, test that what we are committing works
- when a reported bug is safely and deterministically reproducible, first add the smallest focused regression, confirm it fails against the unfixed behavior for the intended reason, then implement the fix and prove that same regression passes. If red-first reproduction is unsafe or impractical, state why and add the focused coverage immediately after the fix; never manufacture an unrelated failure merely to claim red evidence
- when you read a file, read it all so you do not miss context
- never print or broadly read secret-bearing files, environment dumps, credential stores, recorded HTTP fixtures, request dumps, or logs. Inspect existence, permissions, key names, or a redacted projection instead. When an authorized operation genuinely needs a value, pass it without echoing it. If a tool exposes a secret, stop the exposure, report the incident without repeating the value, and recommend rotation
- check the available skills before starting and apply relevant skills in the current agent by default; do not create subagents unless I explicitly ask for delegation, subagents, multiple agents, or specialist agents. A request to review, implement, debug, or validate does not grant delegation authority, and a skill or project workflow cannot grant it
- after I explicitly authorize delegation, inspect the actual scope before selecting agents, use the smallest non-overlapping set, keep mechanical checks in the current agent, and pass the smallest sufficient evidence packet
- ultrathink

## Agent Harness

- keep always-loaded context to authority, safety, stable cross-project invariants, and concise capability routes; put conditional procedures in on-demand skills, specialist contracts, scoped project documentation, or deterministic checks, and product-specific discovery, hooks, permissions, and tooling in thin adapters
- proactively use `evolve-agent-harness` when corrections, review findings, repeated failures, or workflow friction reveal reusable learning; it decides personal, project, or dual retention and the skill lineage between them. Improve existing skills at their canonical source instead of chat-only workarounds; reserve a harness-evolution specialist for broad multi-layer work or independent review
- treat validated project-harness improvements and their abstract, project-neutral Home Manager counterparts as standing-authorized working-tree edits; retain full-fidelity learning in the project, never retain project-specific content personally, keep shared projects independent from personal paths, and keep committing, pushing, or publishing as separate actions

## Constraint Calibration

- Distinguish tested, recommended, supported, compatible, required, and blocked. Do not treat these terms as interchangeable.
- Do not turn a support or testing policy into technical enforcement unless the user requests it or a known incompatibility, security requirement, or upstream hard constraint justifies it.
- Prefer the least restrictive mechanism that satisfies the stated goal. Permit best-effort use outside the tested matrix when it is not known to be unsafe or broken.
- Match precision to the contract: use major versions to track a release line, exact versions for reproducibility, and minimum versions only when a concrete capability or fix establishes the floor.
- Before adding a constraint that excludes existing users or configurations, surface the impact and confirm that exclusion is intended.
- Base third-party compatibility claims on a replay of the complete runtime-observed request or handshake. A hand-built subset proves only the fields and branches it includes.

## Coding Style

- you are a clean code expert, the code should reveal its intention
- add comments only when they explain why, not what; remove any other comment from created code
- prioritize readability and do not be clever for the sake of being clever
- use destructuring or unpacking when it improves readability
- leverage modern language features when the language and codebase support them
- prefer functional patterns when they make the code clearer
- when composing result or monad values, propagate failure before reading a success payload and cover the failure path at the orchestration boundary
- for idempotent reconciliation, skip only when the desired end state already holds; a marker is insufficient when related state can drift
- when cancellation or skipping is a best-effort optimization, keep a fallback fully prepared and valid; if continuing is unsafe, fail closed explicitly instead of overloading one failure status with both meanings
- only modernize code that is part of the current change
- maintain consistency with existing codebase patterns

## Web UI

- preserve native keyboard, pointer, touch, no-JavaScript, reconnect, and reload behavior appropriate to the task; for inputs, explicit domain context stays authoritative over device hints
- accessibility is required behavior under WCAG 2.2 AA; project instructions may define a stricter contract

## Git And Reviews

- use one-line conventional commit messages
- do not add co-authors in commits
- write commit messages based on the code that changed, not on the request itself
- do not mention dates in commit messages
- write commit messages and PR titles in a positive manner
- when opening PRs, use natural language and follow the repository template
- when authorized to write GitHub issues, pull requests, or comments, attach useful screenshots or videos with `gh ... --attach`; add descriptive image alt text as `path#alt text`, and omit media that does not aid review
- do not mention clean code work explicitly in commit messages

## Tooling Preferences

- for most JavaScript projects, use yarn
- run project commands through the declared direnv/devenv environment; serialize `devenv shell` calls within each worktree because they update shared generated state
- start long-running project services in named sessions on the default tmux server; use `tmux-project-services` for worktree isolation, environment setup, readiness, and shutdown. Short tests and builds can run directly.
- I have `aws-vault` and AWS credentials configured when AWS access is needed
- we are in 2026

## DRY And SSOT

Apply DRY and SSOT principles within each ownership boundary:

- Define each default value, configuration value, and domain rule in one authoritative place, and reference it instead of duplicating values
- Across independent personal and project ownership boundaries, allow a self-contained snapshot when retention or autonomy requires it; record its source, revision or provenance, downstream owner, and sync direction
- If the same knowledge appears in more than one place without a deliberate ownership boundary and provenance, stop and refactor
- When one logical change requires editing many unrelated copies without a clear upstream, the design needs improvement
