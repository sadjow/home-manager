# AGENTS.md

This file is managed from `~/.config/home-manager/home/AGENTS.md` through Home Manager.
Use `~/.config/home-manager` as the source of truth for agent tooling and environment changes on this machine.

## Workflow

- don't post comments to GitHub without my authorization
- do not send messages, emails, SMS, or any other outbound communication without my authorization
- no need to use `git -C` if you are already in the project directory
- avoid using `--` when writing text so it keeps a natural tone
- before committing, test that what we are committing works
- when you read a file, read it all so you do not miss context
- for AI tooling and declarative environment changes, update `~/.config/home-manager` instead of editing generated files in `$HOME`
- keep shared instructions and skills agent-agnostic; confine product-specific discovery, metadata, hooks, permissions, and tool configuration to thin adapters
- check the available skills before starting and use the relevant ones
- proactively use `evolve-agent-harness` when corrections, review findings, repeated failures, or workflow friction reveal a possible reusable learning; promote only evidence-backed changes at the right scope and control layer
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

Apply DRY and SSOT principles:

- Define each default value, configuration value, and domain rule in one authoritative place
- Reference the source of truth instead of duplicating values
- If the same knowledge appears in more than one place, stop and refactor
- When one logical change requires editing many unrelated copies of the same value, the design needs improvement

```js
// Avoid duplicated knowledge
Component1: { defaultFee: 50 }
Component2: { defaultFee: 50 }

// Prefer a single source of truth
const CONFIG = { defaultFee: 50 }
Component1: { defaultFee: CONFIG.defaultFee }
Component2: { defaultFee: CONFIG.defaultFee }
```
