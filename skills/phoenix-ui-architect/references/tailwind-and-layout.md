# Tailwind and layout

## Follow the installed Tailwind generation

Inspect the Tailwind version and repository CSS entrypoint. Tailwind v4 uses a
CSS-first configuration and `@theme`; earlier projects may use a JavaScript
configuration. Do not copy version-specific syntax across that boundary.

Centralize values that carry shared meaning:

- semantic surface, text, action, border, and status colors;
- typography roles and readable measures;
- spacing or safe-area values reused across independent consumers;
- radii, elevation, and motion timings that form a coherent system.

Do not tokenize a one-off value merely to avoid a literal. Primitive, semantic,
and component tokens are useful only when ownership remains clear.

## Compose layout predictably

- The component owns internal padding; the parent owns external gap, placement,
  and responsive relationship.
- Start with the narrowest supported width and add layout complexity when
  content requires it. Choose breakpoints from actual wrapping and task
  geometry, not device labels alone.
- Keep one horizontal-padding owner. Use full-width visual bands with an inner
  readable container when a landing page needs breadth.
- Align complete field controls when adjacent translated labels wrap, or stack
  before the row becomes ambiguous.
- Reserve dimensions/aspect ratios for async media and state replacements to
  prevent layout shifts.

## Motion and themes

Animate `opacity` and `transform` for routine feedback and profile exceptions
before animating layout or expensive filters. Preserve a reduced-motion path
and do not use `transition-all` as a substitute for identifying the changing
property.

Add theme variants only when the product requires them. Override semantic
tokens rather than scattering theme-specific utility branches. Test contrast
and system controls such as `color-scheme` for the modes actually supported.

Primary reference: <https://tailwindcss.com/docs/theme>
