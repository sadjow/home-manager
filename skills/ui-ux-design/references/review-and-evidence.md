# Review and evidence

## Review in impact order

1. Can the person find, understand, and complete the primary task?
2. Is system status visible and is failure recovery actionable?
3. Are semantics, keyboard/touch, focus, contrast, reflow, and reduced motion
   correct?
4. Is the information hierarchy clear and free of competing actions?
5. Does the layout use space well across narrow and wide viewports?
6. Are component states and patterns consistent with the existing system?
7. Does motion clarify state without instability or delay?
8. Do decorative choices strengthen the product rather than imitate a trend?

Classify findings as task blocker, accessibility/conformance defect, business
risk, responsive defect, consistency debt, performance concern, or aesthetic
preference. Do not inflate polish into a release blocker.

## Gather evidence

- Inspect the actual rendered surface at narrow and desktop widths.
- Exercise the real pointer, touch, and keyboard journey.
- Simulate meaningful latency for network-backed state.
- Check long content, translation, empty/error/loading states, and reduced
  motion.
- Use screenshots for composition and traces/video/frames for temporal bugs.
- Check analytics, support evidence, or observed attempts before redesigning a
  funnel around intuition.

Automated audits and screenshots support accessibility and UX review but do not
prove task completion, announcement quality, gesture cancellation, or mental
model fit.

## Hand off decisions

Lead with the expected user outcome and highest-impact changes. Distinguish
evidence from inference, record trade-offs and deferred scope, and define a
concrete validation action for remaining assumptions.
