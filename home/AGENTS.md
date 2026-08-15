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
- keep shared guidance agent-agnostic and always-loaded context limited to authority, safety, stable cross-project invariants, and concise capability routes; place conditional procedures in on-demand skills, bounded specialist contracts, scoped project documentation, or deterministic checks, and confine product-specific discovery, metadata, hooks, permissions, and tooling to thin adapters
- check the available skills before starting and apply relevant skills in the current agent by default; delegate only when independent judgment, context isolation, or parallel ownership materially helps, and pass the smallest sufficient evidence packet
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
- only modernize code that is part of the current change
- maintain consistency with existing codebase patterns

## Semantic Inputs

- When deterministic syntax can be checked in the browser, provide local,
  latency-independent feedback while the person types. Distinguish an
  incomplete draft from an impossible value and do not require a network or
  server event for per-keystroke syntax feedback.
- Derive formatting from explicit field context, keep server-side domain
  validation authoritative, and preserve caret, selection, paste, autofill,
  IME composition, reconnect, and no-JavaScript submission. Normalize at a
  stable boundary such as blur when rewriting during typing would harm editing.
  When progressive formatting is expected, prove intermediate keystrokes,
  mid-string insertion, deletion beside separators, and logical cursor
  stability rather than testing only the value after blur. Keep format guidance
  persistently visible and associated with the field; a disappearing
  placeholder is not sufficient instruction. Exercise the supported desktop
  and mobile browser profiles when keyboard or `beforeinput` event ordering can
  differ.
- Treat browser and device regional values as optional suggestions, not
  authority. They may fill only a blank, unreviewed value once and must never
  overwrite an explicit user or domain context, mutate a non-empty hidden or
  submitted field, or reapply after a reactive render. Test with the browser
  locale deliberately different from the explicit authoring locale.

## Responsive Interaction QA

- Do not commit an action on pointerdown when the same surface can scroll,
  pan, drag, or otherwise cancel the gesture. Preserve any browser draft or
  focus needed to survive a reactive render, but finalize only after an
  intentional pointerup; cancel on meaningful movement, `pointercancel`,
  release outside, disconnect, or destruction. Keep keyboard activation
  native. Prove a held first press plus a real touch pan that begins on an
  unselected target under latency; a synthetic click does not cover pointer
  cancellation.
- In reactive forms, a focused or debounced field must not make the first
  pointer or keyboard action disappear. If a render can replace the target
  between pointerdown and click, or consume Enter while applying a pending
  field update, submit the current browser draft before that boundary. Keep
  browser constraint validation, submitter intent, single-flight behavior,
  native semantics, and no-JavaScript submission intact. Prove a deliberately
  held first press plus Enter and Space under latency instead of testing only
  an already-unfocused form.
- A primary task-entry link present in server-rendered HTML must work before a
  reactive client has joined or reconnected. Prefer a real canonical `href`
  when a full navigation is acceptable; do not make the first meaningful
  action depend only on an active socket. Test the cold-entry click with a
  deliberately delayed connection.
- When a focused form navigates to a new task, make the intended landing
  explicit. Focus with `preventScroll`, account for bounded mobile
  visual-viewport changes after keyboard dismissal, and verify scroll and
  viewport-relative destination geometry after the real submit.
- Do not assume adjacent translated labels have equal height. Stack their
  fields before wrapping makes the row ambiguous, or align the complete field
  boxes by their controls. Test the longest supported label at the breakpoint
  where the layout changes.

## Accessibility

- Treat accessibility as required behavior from design through validation, not
  as final visual polish. Use WCAG 2.2 AA as the default baseline when the
  project has not defined a stricter contract.
- Prefer native elements and semantics before ARIA. Every supported task must
  work with keyboard, pointer, and touch; focus must remain visible,
  unobscured, intentionally placed, and restored after overlays.
- Give dynamic success, failure, and progress a concise programmatic
  announcement. Do not encode meaning only through color, shape, position,
  sound, motion, placeholder text, or an icon.
- Verify reflow, large text and zoom, contrast, reduced motion, translated
  labels, and practical target sizes. Automated audits, screenshots, and
  accessibility-tree inspection are supporting evidence, not proof; exercise
  the real keyboard journey and a screen reader for high-risk flows.
- Distinguish an accessibility defect from an aesthetic preference. Block a
  release when a required task cannot be perceived, understood, or completed
  in a supported mode; describe non-blocking visual refinements separately.
- Acquisition pages may use persuasive composition and full-width visual
  bands, while internal task pages remain compact and operational. In either
  case, assign horizontal padding to one owner, keep readable line lengths,
  avoid competing navigation, and preserve semantic, keyboard, reflow, and
  reduced-motion behavior.

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
- when a repository declares a direnv or devenv environment, run project commands through it instead of using system language runtimes
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
