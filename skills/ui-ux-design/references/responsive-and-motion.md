# Responsive behavior and motion

## Responsive layout

Begin at 320 CSS px or the project's narrowest supported width. Add breakpoints
where content, controls, or reading order need a different composition. Test
the longest supported labels and content, not only a convenient sample.

- Avoid fixed widths for text/task regions.
- Reserve media aspect ratios and async content slots.
- Account for safe areas, virtual keyboards, and persistent headers/footers.
- Align controls rather than label baselines when translated labels wrap; stack
  before a row becomes ambiguous.
- Keep the final primary action visible and reachable.
- Provide mouse/keyboard alternatives for touch gestures and avoid hover-only
  actions.

Container queries can adapt reusable components while media queries shape page
composition. Choose them from ownership, not novelty.

## Interaction states

Every actionable control needs perceivable default, hover where relevant,
pressed, focus, disabled/unavailable, pending, success, and error behavior as
the task requires. Do not make disabled state the only explanation; provide the
reason when it is not obvious.

Pending feedback appears locally and preserves the control's meaning and size.
Use skeletons only when their geometry resembles the final content and the
loading duration warrants them.

## Motion

Use motion to communicate origin, relationship, progress, or completion.
Routine transitions generally use `opacity` and `transform`; avoid
`transition-all` and layout-property animation unless profiling and product
need justify it.

Keep durations proportional to distance and consequence. Entry often uses an
ease-out and exit a slightly faster ease-in, but measure within the product.
Avoid mandatory bounce, parallax, autoplay, or decorative movement.

Under reduced motion, remove large spatial movement and pulsing while retaining
immediate visibility, focus, status, and lifecycle completion.
