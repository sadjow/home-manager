# Forms and navigation

## Forms

- Build a `Phoenix.HTML.Form` with `to_form/2` and drive the template from that
  form. Keep changesets in the server layer.
- Reuse the project's field component so label, help, required state,
  `aria-describedby`, invalid state, and errors remain consistent.
- Give every form and task control a stable unique DOM ID.
- Preserve native submit and browser validation. Do not turn every field change
  into a server round trip when deterministic syntax can be handled locally.
- Keep authored browser state safe from patches. When a focused/debounced field
  can race the first action, use the resilient interaction contract rather than
  adding a delay.

## Layouts and route scope

Inspect how the pinned Phoenix version and repository invoke layouts. Pass the
authentication/current-scope assigns required by the local layout and place
routes in the matching `live_session`/`on_mount` boundary.

Root layout `<head>` content may persist across live navigation. If robots,
canonical, trust, or capability-sensitive metadata differs by surface, either
implement an explicit route-aware head update or use a full `href` navigation
and verify the resulting document head.

Use `handle_params/3` for URL-owned state such as filters, selected resources,
and bookmarkable task identity. Never place passwords, tokens, private drafts,
or sensitive data in the URL.

## Focus and task transitions

Set a meaningful page title and heading for each task. After navigation, place
focus deliberately without causing stale viewport geometry to scroll content
under fixed chrome. Modal/sheet work also needs containment, Escape, and focus
return; use the accessibility and resilient-interaction workflows for the full
contract.

Primary references:

- Form bindings: <https://hexdocs.pm/phoenix_live_view/form-bindings.html>
- Live navigation: <https://hexdocs.pm/phoenix_live_view/live-navigation.html>
- Security model: <https://hexdocs.pm/phoenix_live_view/security-model.html>
