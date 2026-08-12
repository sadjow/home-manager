# UI/UX Review Checklist

Score each section and prioritize fixes by impact.

## Nielsen's Usability Heuristics

- [ ] **System status visible** — loading indicators, progress bars, success/error feedback
- [ ] **Real-world match** — familiar language, natural information order, domain conventions
- [ ] **User control** — undo, cancel, back, close. Always an "emergency exit"
- [ ] **Consistency** — same action = same result = same look everywhere
- [ ] **Error prevention** — disable invalid states, confirm destructive actions, inline validation
- [ ] **Recognition > recall** — visible options, recent history, contextual hints
- [ ] **Flexibility** — keyboard shortcuts for power users, simplified path for beginners
- [ ] **Minimal design** — every element earns its place; remove what doesn't serve a purpose
- [ ] **Error recovery** — clear error messages explaining what happened and how to fix it
- [ ] **Help when needed** — contextual tooltips, progressive onboarding, not walls of documentation

## Visual Hierarchy

- [ ] Primary action is visually dominant (size, color, contrast)
- [ ] Information flows in logical reading order
- [ ] Related items grouped, unrelated items separated by whitespace
- [ ] Typography hierarchy is clear (headings > body > captions)
- [ ] Whitespace is consistent and intentional — not random
- [ ] Color is used semantically (indigo=action, red=destructive, green=success, gray=secondary)

## Interaction Feedback

- [ ] Every clickable element has a hover state
- [ ] Buttons have active/press feedback (`active:scale-95`, color change)
- [ ] Form inputs show focus ring on keyboard navigation
- [ ] Loading states exist for all async operations (skeleton or spinner)
- [ ] Success feedback is immediate (checkmark, color flash, text confirmation)
- [ ] Error feedback is clear (shake, red highlight, plain-language message)
- [ ] Destructive actions require confirmation dialog
- [ ] State changes are animated, not instant (toggled? transitioned? collapsed?)

## Spacing & Density

- [ ] Consistent spacing scale (Tailwind's scale, not arbitrary values)
- [ ] Touch targets meet 44x44px minimum on mobile
- [ ] Content density matches context (compact for panels, spacious for focus views)
- [ ] Padding inside containers is uniform
- [ ] Gaps between list items are uniform
- [ ] No wasted whitespace that could show more content

## Responsive / Mobile-First

- [ ] Layout works at 375px (iPhone SE)
- [ ] No horizontal overflow at any breakpoint
- [ ] Touch targets are large enough on mobile
- [ ] Text is readable without zooming (min 14px body)
- [ ] Modals/panels adapt to mobile (bottom sheet or full-width pattern)
- [ ] Long content truncates or wraps gracefully
- [ ] Navigation is thumb-reachable (bottom of screen for mobile actions)

## Animation & Motion

- [ ] Entrances use `ease-out`, exits use `ease-in`
- [ ] Durations are 200-300ms (micro-interactions), 300-500ms (layout transitions)
- [ ] No animation causes layout shift (CLS)
- [ ] Motion respects `prefers-reduced-motion` / `motion-safe:`
- [ ] Only `transform` and `opacity` are animated (GPU-friendly, 60fps)
- [ ] Animations feel purposeful — guide attention, confirm actions
- [ ] No animation is purely decorative without functional value

## Accessibility

- [ ] Color contrast meets WCAG AA (4.5:1 text, 3:1 large text/icons)
- [ ] Interactive elements keyboard-navigable (Tab, Enter, Escape)
- [ ] Focus indicators visible on all interactive elements
- [ ] Images have meaningful alt text
- [ ] Form inputs have associated labels (not just placeholder)
- [ ] ARIA roles on custom interactive elements (buttons, toggles, tabs)
- [ ] `aria-live` regions for dynamic content changes (flash messages, live updates)
- [ ] Reduced motion alternative for all animations

## Polish Indicators

- [ ] Consistent border-radius across similar elements
- [ ] Icons same style family and consistent size
- [ ] Colors from defined palette (semantic, not random hex)
- [ ] Transitions are smooth (no visual jumps or flicker)
- [ ] Empty states are designed (icon + message + action)
- [ ] Error states are designed (not raw error text or stack traces)
- [ ] Shadows follow depth system (sm → md → lg → xl)
- [ ] No orphaned text (single words on their own line)

## Performance

- [ ] No layout shift on load (skeleton screens match final layout)
- [ ] Images lazy-loaded below the fold
- [ ] Animations don't block main thread
- [ ] No excessive re-renders in LiveView (check assigns carefully)
- [ ] CSS is purged in production (Tailwind JIT removes unused)

## Priority Matrix

| Impact | Effort | Action |
|--------|--------|--------|
| High | Low | Fix now — missing hover states, broken spacing, no loading state |
| High | High | Plan next — responsive redesign, animation system, design tokens |
| Low | Low | Quick win — icon consistency, border radius, shadow alignment |
| Low | High | Defer or skip |
