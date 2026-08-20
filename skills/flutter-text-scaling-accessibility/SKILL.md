---
name: flutter-text-scaling-accessibility
description: Test, review, or implement Flutter interfaces for large and platform-driven text scaling, including nonlinear TextScaler behavior. Use when Flutter work involves accessibility font sizes, text overflow or clipping, large-text layout support, or claims about Android or iOS text-size settings.
---

# Flutter Text Scaling Accessibility

Make Flutter interfaces remain understandable and operable under the text-size settings they claim to support. Keep synthetic widget-test coverage distinct from evidence about real platform behavior.

## Keep the scope precise

- Use this skill for Flutter text scaling and the layout behavior it affects.
- Use broader Flutter accessibility guidance for semantics, focus, contrast, screen readers, and target sizes.
- Preserve the project's declared platform and accessibility support. Do not invent a universal numeric scale requirement.

## Model scaling faithfully

- Prefer Flutter's current `TextScaler` and `MediaQuery.textScalerOf(context)` APIs when production behavior depends on the platform scaler.
- Treat a numeric value such as `TextScaler.linear(2)` as a synthetic test input unless the test harness replays the target platform's actual scaler.
- Do not equate an Android or iOS text-size category with a fixed numeric multiplier without verifying the current platform and Flutter mapping from authoritative sources.
- Account for nonlinear scaling and font-dependent metrics. A single multiplier can produce different effective sizes across text styles and platforms.
- Avoid fixed-height text containers, avoid scaling text down merely to prevent overflow, and preserve reflow, reading order, and access to actions.

## Build useful automated coverage

- Exercise representative small, medium, and large text styles through the same layout path used in production.
- Cover wrapping, truncation, scrolling, flexible constraints, translated copy, and actions adjacent to text.
- Prefer behavioral assertions about visibility and operability over screenshot-only evidence.
- When using a synthetic scaler, state what it proves and what platform behavior it does not reproduce.
- Keep automated coverage separate from a claim that an OS accessibility setting or category is supported.

## Validate platform behavior

- Verify the maximum text-size setting within the declared support boundary through the operating system settings on a supported device.
- Use an emulator or simulator as platform evidence only when it faithfully reproduces the relevant scaler and font metrics; otherwise verify on real hardware.
- Recheck platform-category mappings against current official documentation when support claims, regression tests, or acceptance criteria depend on them.
- Test the complete task at large text, not only isolated text rendering. Confirm that content remains perceivable and controls remain reachable and operable.

## Authoritative references

- [Flutter accessibility UI design and large-font guidance](https://docs.flutter.dev/ui/accessibility/ui-design-and-styling)
- [Flutter migration guidance for nonlinear Android text scaling](https://docs.flutter.dev/release/breaking-changes/android-14-nonlinear-text-scaling-migration)
- [Flutter migration from `textScaleFactor` to `TextScaler`](https://docs.flutter.dev/release/breaking-changes/deprecate-textscalefactor)
