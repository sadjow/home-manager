# AGENTS.md

Managed by Home Manager from `~/.config/home-manager/home/AGENTS.md`. Global instructions and environment changes belong in `~/.config/home-manager`. Public skills belong in the `sadjow/skills` checkout; private skills belong in the private checkout. Never edit installed skill copies or Nix store files. Project-specific harness changes belong in their project repository.

## Workflow

- don't post comments to GitHub without my authorization
- do not send messages, emails, SMS, or any other outbound communication without my authorization
- never print or broadly read secret-bearing files, environment dumps, credential stores, recorded HTTP fixtures, request dumps, logs, or browser consoles. Inspect existence, permissions, key names, or a redacted projection instead. When an authorized operation genuinely needs a value, pass it without echoing it. If a tool exposes a secret, stop the exposure, report the incident without repeating the value, and recommend rotation
- after interrupting or timing out a command that can change remote or shared state, check process and target-state evidence before you retry it or report whether it ran; child processes can outlive their wrapper and still apply the change
- when posting comments or updates on my behalf, write in my voice without referring to me by name or in the third person. Keep claims grounded in what was actually done or verified
- write self-contained deliverables that describe the final result, such as the final diff, not how it was reached. Omit instruction and conversation context unless requested or necessary for readers: paraphrased instructions, my constraints restated as rationale, commentary on how the deliverable itself is written, and earlier revisions. Keep the change's own rationale, scope, evidence, risks, and limitations; report outcomes and validation
- read files in full so you do not miss context
- check the available skills before starting and apply relevant skills
- before committing, verify that the changes work
- for safely, deterministically reproducible bugs, add the smallest focused regression, confirm it fails for the intended reason, then fix and prove it passes. If red-first reproduction is unsafe or impractical, explain why and add focused coverage immediately after fixing; never manufacture unrelated failures to claim red evidence
- skip `git -C` when already in the project directory
- whenever you mention a pull request, issue, or other remote resource, write it as a markdown link whose text is its identifier and title, such as `[PR #147: update devenv inputs](<url>)`, so it opens directly from the terminal
- avoid `--` in prose so it keeps a natural tone
- ultrathink

## Agent Harness

- keep always-loaded context to authority, safety, stable cross-project invariants, and concise capability routes; put conditional procedures in on-demand skills, specialist contracts, scoped project documentation, or deterministic checks, and product-specific discovery, hooks, permissions, and tooling in thin adapters
- proactively use `evolve-agent-harness` when corrections, review findings, repeated failures, or workflow friction reveal reusable learning
- treat validated project-harness improvements and their abstract, project-neutral Home Manager counterparts as standing-authorized working-tree edits; retain full-fidelity learning in the project, never retain project-specific content personally, keep shared projects independent from personal paths, and keep committing, pushing, or publishing as separate actions

## Constraint Calibration

- Distinguish tested, recommended, supported, compatible, required, and blocked; they are not interchangeable.
- Do not turn a support or testing policy into technical enforcement unless the user requests it or a known incompatibility, security requirement, or upstream hard constraint justifies it.
- Prefer the least restrictive mechanism that satisfies the stated goal. Permit best-effort use outside the tested matrix when it is not known to be unsafe or broken.
- Match precision to the contract: use major versions to track a release line, exact versions for reproducibility, and minimum versions only when a concrete capability or fix establishes the floor.
- Before adding a constraint that excludes existing users or configurations, surface the impact and confirm that exclusion is intended.
- Base third-party compatibility claims on a replay of the complete runtime-observed request or handshake. A hand-built subset proves only the fields and branches it includes.

## Coding Style

- you are a clean code expert, the code should reveal its intention
- add comments only when they explain why, not what; remove any other comment from created code
- prioritize readability over cleverness
- use destructuring or unpacking when it improves readability
- use modern language features the language and codebase support
- prefer functional patterns when they make the code clearer
- when composing result or monad values, propagate failure before reading a success payload and cover the failure path at the orchestration boundary
- for idempotent reconciliation, skip only when the desired end state already holds; a marker is insufficient when related state can drift
- when a write replaces more state than its caller changed, such as a whole list for a one-item move, compare all of that state with what the caller last read or apply only the change; checking part of it, such as membership without order, lets a stale view revert another writer's work; likewise, interpret a relative command, such as move up, against the state its control was drawn from rather than the latest state
- when cancellation or skipping is a best-effort optimization, keep a fallback fully prepared and valid; if continuing is unsafe, fail closed explicitly instead of overloading one failure status with both meanings
- only modernize code that is part of the current change
- maintain consistency with existing codebase patterns, but in new or rewritten code follow the documented target of patterns project guidance marks deprecated or migration debt, even where neighbors still use them

## Web UI

- preserve native keyboard, pointer, touch, no-JavaScript, reconnect, and reload behavior appropriate to the task; for inputs, explicit domain context stays authoritative over device hints
- accessibility is required behavior under WCAG 2.2 AA; project instructions may define a stricter contract

## Git And Reviews

- when committing skill changes, commit the task's validated changes in each canonical skills repository, excluding unrelated work; push requests include those commits, and private skills go only to a verified private remote
- use one-line conventional commit messages
- do not add co-authors in commits
- write commit messages based on the code that changed, not on the request itself
- do not mention dates in commit messages
- write commit messages and PR titles positively
- when opening PRs, use natural language and follow the repository template
- attach useful screenshots or videos to authorized GitHub issues, pull requests, or comments with `github-media-attachments`
- do not mention clean code work explicitly in commit messages
- when reviewing a pull request, add a design lens (single responsibility, substitutable siblings, small interfaces, dependency direction, one owner per rule or default) next to correctness; report design findings as suggestions unless duplicated knowledge or a contract mismatch between siblings can produce divergent behavior, and never ask for an abstraction without a current second caller

## Tooling Preferences

- for most JavaScript projects, use yarn
- run project commands through the declared direnv/devenv environment; serialize `devenv shell` calls within each worktree because they update shared generated state
- start long-running project services in named tmux sessions with `tmux-project-services`; short tests and builds can run directly
- for AWS access, run commands through `aws-vault`; default to the account's `*-readonly` profile, which assumes a read-only role, and use the writable profile only when I explicitly ask for a change in that account
- we are in 2026

## DRY And SSOT

Apply DRY and SSOT principles within each ownership boundary:

- Define each default value, configuration value, and domain rule in one authoritative place, and reference it instead of duplicating values
- If the same knowledge appears in several places, or one logical change requires editing many unrelated copies, without a deliberate ownership boundary and provenance, stop and refactor
