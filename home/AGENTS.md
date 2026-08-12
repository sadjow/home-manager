# AGENTS.md

This file is managed from `~/.config/home-manager/home/AGENTS.md` through Home Manager.
Treat `~/.config/home-manager` as the canonical source for personal, cross-project agent instructions, skills, AI tooling, and environment changes on this machine. Treat each project repository as canonical for its project-specific harness.

## Workflow

- don't post comments to GitHub without my authorization
- do not send messages, emails, SMS, or any other outbound communication without my authorization
- no need to use `git -C` if you are already in the project directory
- avoid using `--` when writing text so it keeps a natural tone
- before committing, test that what we are committing works
- when you read a file, read it all so you do not miss context
- for personal agent-harness and declarative environment changes, update `~/.config/home-manager` instead of generated files in `$HOME`
- keep shared instructions and skills agent-agnostic; confine product-specific discovery, metadata, hooks, permissions, and tool configuration to thin adapters
- check the available skills before starting and use the relevant ones
- treat agent skills as maintainable code; improve existing personal or project-specific skills at their canonical source when evidence supports it instead of accumulating chat-only workarounds
- treat validated project-harness improvements and their abstract, project-neutral Home Manager counterparts as standing-authorized working-tree edits; retain full-fidelity learning in the project, never retain project-specific content personally, and keep committing, pushing, or publishing as separate actions
- when a portable personal skill can help a project, derive a self-contained project-owned adaptation without removing the personal source; retain subsequent learning in the project and feed its abstract principle back into the personal skill
- proactively use `evolve-agent-harness` when corrections, review findings, repeated failures, or workflow friction reveal a possible reusable learning; decide whether it belongs in personal Home Manager, the project, or both, and keep shared projects independent from personal home-directory paths
- ultrathink

## Constraint Calibration

- Distinguish tested, recommended, supported, compatible, required, and blocked. Do not treat these terms as interchangeable.
- Do not turn a support or testing policy into technical enforcement unless the user requests it or a known incompatibility, security requirement, or upstream hard constraint justifies it.
- Prefer the least restrictive mechanism that satisfies the stated goal. Permit best-effort use outside the tested matrix when it is not known to be unsafe or broken.
- Match precision to the contract: use major versions to track a release line, exact versions for reproducibility, and minimum versions only when a concrete capability or fix establishes the floor.
- Before adding a constraint that excludes existing users or configurations, surface the impact and confirm that exclusion is intended.

## Coding Style

- you are a clean code expert, the code should reveal its intention
- when adding comments to the code, only add comments that explain why, not what
- remove comments from created code unless they explain why
- prioritize readability and do not be clever for the sake of being clever
- use destructuring or unpacking when it improves readability
- leverage modern language features when the language and codebase support them
- prefer functional patterns when they make the code clearer
- only modernize code that is part of the current change
- maintain consistency with existing codebase patterns

## Git And Reviews

- use one-line conventional commit messages
- do not add co-authors in commits
- write commit messages based on the code that changed, not on the request itself
- do not mention dates in commit messages
- write commit messages and PR titles in a positive manner
- when opening PRs, use natural language and follow the repository template
- do not mention clean code work explicitly in commit messages

## Tooling Preferences

- for most JavaScript projects, use yarn
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
