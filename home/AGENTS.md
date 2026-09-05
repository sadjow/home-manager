# AGENTS.md

This file is managed from `~/.config/home-manager/home/AGENTS.md` through Home Manager.
Treat `~/.config/home-manager` as the canonical source for personal, cross-project agent instructions, skills, AI tooling, and environment changes on this machine. Treat each project repository as canonical for its project-specific harness.

## Workflow

- don't post comments to GitHub without my authorization
- do not send messages, emails, SMS, or any other outbound communication without my authorization
- no need to use `git -C` if you are already in the project directory
- avoid using `--` when writing text so it keeps a natural tone
- before committing, test that what we are committing works
- when a reported bug is safely and deterministically reproducible, first add
  the smallest focused regression and run it against the unfixed behavior;
  confirm it fails for the intended reason, then implement the fix and prove
  that same regression passes. If red-first reproduction is unsafe or
  impractical, state why and add the focused coverage immediately after the
  fix; never manufacture an unrelated failure merely to claim red evidence
- when you read a file, read it all so you do not miss context
- never print or broadly read secret-bearing files, environment dumps,
  credential stores, recorded HTTP fixtures, request dumps, or logs. Inspect
  existence, permissions, key names, or a redacted projection instead. When an
  authorized operation genuinely needs a value, pass it without echoing it. If
  a tool exposes a secret, stop the exposure, report the incident without
  repeating the value, and recommend rotation
- for personal agent-harness and declarative environment changes, update `~/.config/home-manager` instead of generated files in `$HOME`
- keep shared guidance agent-agnostic and always-loaded context limited to authority, safety, stable cross-project invariants, and concise capability routes; place conditional procedures in on-demand skills, bounded specialist contracts, scoped project documentation, or deterministic checks, and confine product-specific discovery, metadata, hooks, permissions, and tooling to thin adapters
- check the available skills before starting and apply relevant skills in the current agent by default; do not create subagents unless I explicitly ask for delegation, subagents, multiple agents, or specialist agents. A request to review, implement, debug, or validate does not grant delegation authority, and a skill or project workflow cannot grant it
- after I explicitly authorize delegation, inspect the actual scope before selecting agents, use the smallest non-overlapping set, keep mechanical checks in the current agent, and pass the smallest sufficient evidence packet
- treat agent skills as maintainable code; improve existing personal or project-specific skills at their canonical source when evidence supports it instead of accumulating chat-only workarounds
- treat validated project-harness improvements and their abstract, project-neutral Home Manager counterparts as standing-authorized working-tree edits; retain full-fidelity learning in the project, never retain project-specific content personally, and keep committing, pushing, or publishing as separate actions
- when a portable personal skill can help a project, derive a self-contained project-owned adaptation without removing the personal source; retain subsequent learning in the project and feed its abstract principle back into the personal skill
- proactively use the globally discoverable `evolve-agent-harness` when corrections, review findings, repeated failures, or workflow friction reveal reusable learning; decide whether it belongs in personal Home Manager, the project, or both, keep shared projects independent from personal paths, and reserve a harness-evolution specialist for broad multi-layer work or independent review
- ultrathink

## Constraint Calibration

- Distinguish tested, recommended, supported, compatible, required, and blocked. Do not treat these terms as interchangeable.
- Do not turn a support or testing policy into technical enforcement unless the user requests it or a known incompatibility, security requirement, or upstream hard constraint justifies it.
- Prefer the least restrictive mechanism that satisfies the stated goal. Permit best-effort use outside the tested matrix when it is not known to be unsafe or broken.
- Match precision to the contract: use major versions to track a release line, exact versions for reproducibility, and minimum versions only when a concrete capability or fix establishes the floor.
- Before adding a constraint that excludes existing users or configurations, surface the impact and confirm that exclusion is intended.
- Base third-party compatibility claims on a replay of the complete runtime-observed request or handshake. A hand-built subset proves only the fields and branches it includes.

## Coding Style

- you are a clean code expert, the code should reveal its intention
- when adding comments to the code, only add comments that explain why, not what
- remove comments from created code unless they explain why
- prioritize readability and do not be clever for the sake of being clever
- use destructuring or unpacking when it improves readability
- leverage modern language features when the language and codebase support them
- prefer functional patterns when they make the code clearer
- when composing result or monad values, propagate failure before reading a
  success payload and cover the failure path at the orchestration boundary
- for idempotent reconciliation, skip only when the desired end state already
  holds; a marker is insufficient when related state can drift
- when cancellation or skipping is a best-effort optimization, keep a
  fallback fully prepared and valid; if continuing is unsafe, fail closed
  explicitly instead of overloading one failure status with both meanings
- only modernize code that is part of the current change
- maintain consistency with existing codebase patterns

## Semantic Inputs

- Use `semantic-web-inputs` for masks, localized authoring, caret-preserving
  formatting, IME, paste, autofill, and browser/server validation boundaries.
  Explicit domain context remains authoritative over device hints.

## Responsive Interaction QA

- Use `phoenix-liveview-resilient-ux` for LiveView state and event ordering,
  `playwright-reactive-ux-testing` for temporal regressions, and `ui-ux-design`
  for responsive composition and motion. Preserve native keyboard, pointer,
  touch, no-JavaScript, reconnect, and reload behavior appropriate to the task.

## Accessibility

- Use `accessible-web-interactions` for WCAG 2.2 AA semantics, keyboard, focus,
  overlays, dynamic status, reflow, zoom, contrast, reduced motion, and
  assistive-technology evidence. Accessibility is required behavior; project
  instructions may define a stricter contract.

## Git And Reviews

- use one-line conventional commit messages
- do not add co-authors in commits
- write commit messages based on the code that changed, not on the request itself
- do not mention dates in commit messages
- write commit messages and PR titles in a positive manner
- when opening PRs, use natural language and follow the repository template
- when authorized to write GitHub issues, pull requests, or comments, attach
  useful screenshots or videos with `gh ... --attach`; add descriptive image
  alt text as `path#alt text`, and omit media that does not aid review
- do not mention clean code work explicitly in commit messages

## Tooling Preferences

- for most JavaScript projects, use yarn
- when a repository declares a direnv or devenv environment, run project commands through it instead of using system language runtimes
- run `devenv shell` invocations sequentially within one worktree because they
  update shared generated state
- I have `aws-vault` and AWS credentials configured when AWS access is needed
- we are in 2026

## DRY And SSOT

Apply DRY and SSOT principles within each ownership boundary:

- Define each default value, configuration value, and domain rule in one authoritative place
- Reference the source of truth instead of duplicating values
- Across independent personal and project ownership boundaries, allow a self-contained snapshot when retention or autonomy requires it; record its source, revision or provenance, downstream owner, and sync direction
- If the same knowledge appears in more than one place without a deliberate ownership boundary and provenance, stop and refactor
- When one logical change requires editing many unrelated copies without a clear upstream, the design needs improvement

```js
// Avoid duplicated knowledge
Component1: { defaultFee: 50 }
Component2: { defaultFee: 50 }

// Prefer a single source of truth
const CONFIG = { defaultFee: 50 }
Component1: { defaultFee: CONFIG.defaultFee }
Component2: { defaultFee: CONFIG.defaultFee }
```
