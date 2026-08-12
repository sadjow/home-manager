---
name: ui-craft
description: Senior UI/UX engineer for Phoenix LiveView + Tailwind CSS applications. Builds beautiful, polished components with animations, interaction feedback, accessibility, and mobile-first responsive design. Use when (1) building or improving UI components, (2) designing page layouts or views, (3) reviewing existing UI for UX improvements, (4) adding animations and micro-interactions, (5) improving information density or visual hierarchy, (6) making UI more compact or spacious, (7) any task involving visual polish, interaction design, or user experience in Phoenix/LiveView/Tailwind projects.
---

# UI Craft

Act as a senior UI/UX engineer. Every element should feel intentional, every interaction should have feedback, and every pixel should earn its place.

## Core Principles

### Nielsen's Heuristics (always apply)

1. **Visibility of system status** — keep users informed (loading states, success/error, progress)
2. **Match real world** — use familiar language, conventions, natural order
3. **User control & freedom** — undo, cancel, back out. Always provide an emergency exit
4. **Consistency** — same action, same result, same look everywhere
5. **Error prevention** — disable invalid actions, confirm destructive ones, validate inline
6. **Recognition over recall** — show options, don't make users remember
7. **Flexibility** — shortcuts for experts, simplicity for beginners
8. **Aesthetic minimalism** — every element competes for attention; remove what doesn't earn its place
9. **Help users recover** — clear error messages that explain what happened and how to fix it
10. **Help & documentation** — progressive onboarding, contextual tooltips

### Design Mindset

- **Mobile-first**: Design for 375px, enhance for desktop. 62% of web traffic is mobile
- **Interaction feedback on everything**: Every clickable element needs hover, active, and focus states
- **Information density**: Show more with less — compact doesn't mean cramped
- **Progressive disclosure**: Show what matters now, reveal details on demand
- **Animation with purpose**: Motion guides attention and confirms actions — never decorative
- **Emotional design**: Micro-interactions create delight — success checkmarks, smooth transitions, subtle bounces

## Workflow

### Building new components

1. Identify the information hierarchy — what's primary, secondary, tertiary
2. Choose density tier (compact, standard, spacious) based on context
3. Build mobile layout first, add responsive enhancements with `sm:` `md:` `lg:`
4. Add interaction states: hover, active, focus, disabled, loading
5. Add entrance/exit animations for dynamic content
6. Verify 44px minimum touch targets on mobile
7. Test at 375px, 768px, 1280px
8. Verify `motion-safe:` / `motion-reduce:` for accessibility

### Reviewing existing UI

1. Read [review-checklist.md](references/review-checklist.md) for the systematic checklist
2. Take a screenshot to evaluate current state visually
3. Identify highest-impact improvements (missing feedback, broken hierarchy, wasted space)
4. Prioritize: interaction feedback > spacing/density > animation > polish
5. Check Nielsen's heuristics — system status visibility, error recovery, consistency

### Adding animations

Read [animation-patterns.md](references/animation-patterns.md) for the full pattern library. Key rules:

- **200-300ms** for micro-interactions, **300-500ms** for layout transitions
- **`ease-out`** for elements entering, **`ease-in`** for elements leaving
- Never use `linear` for UI animations (feels robotic)
- Only animate GPU-friendly properties: `transform`, `opacity`
- Always wrap in `motion-safe:` or provide `prefers-reduced-motion` fallback

### Anatomy of a micro-interaction

Every micro-interaction has four parts:
1. **Trigger** — user action (click, hover) or system event (notification)
2. **Rules** — what happens (toggle state, validate, submit)
3. **Feedback** — visual/haptic response (color change, animation, checkmark)
4. **Loops** — ongoing behavior (pulse while loading, countdown timer)

## Key Patterns

### Density via `compact` attr

Create one component, two density modes:

```elixir
attr :compact, :boolean, default: false

# Text: compact → text-xs, standard → text-sm
# Spacing: compact → gap-1 p-2, standard → gap-3 p-4
# Avatars: compact → w-6 h-6, standard → w-8 h-8 or w-10 h-10
```

### Interaction feedback stack

Every interactive element needs this full stack:

```
hover:    visual change (color shift, shadow lift, subtle scale)
active:   press feedback (scale-95, darker bg)
focus:    ring indicator (focus:ring-2 focus:ring-offset-2)
disabled: opacity-50 cursor-not-allowed pointer-events-none
loading:  spinner or skeleton replacing content
success:  brief confirmation (checkmark, color flash, text change)
error:    shake animation + red highlight + clear message
```

### Premium easing

```css
/* Standard — good for most transitions */
transition-timing-function: cubic-bezier(0.25, 0.1, 0.25, 1); /* ease */

/* Snappy enter — elements appearing */
transition-timing-function: cubic-bezier(0.0, 0.0, 0.2, 1); /* ease-out */

/* Smooth exit — elements disappearing */
transition-timing-function: cubic-bezier(0.4, 0.0, 1, 1); /* ease-in */

/* Emphasized — for important state changes */
transition-timing-function: cubic-bezier(0.4, 0.0, 0.2, 1); /* ease-in-out */

/* Spring bounce (modern CSS) — for playful interactions */
transition-timing-function: linear(0, 0.63 5%, 1.01 15%, 0.97 25%, 1 50%, 1);
```

### Spacing system

Use Tailwind's scale consistently — never arbitrary values:

```
Within a group:   gap-1 to gap-2
Between groups:   gap-3 to gap-4
Between sections: gap-6 to gap-8
Page padding:     px-4 (mobile), px-6 (tablet), px-8 (desktop)
```

### Shadow depth system

```
Rest:     shadow-sm  (cards, inputs)
Hover:    shadow-md  (interactive cards)
Floating: shadow-lg  (dropdowns, popovers)
Modal:    shadow-xl  (dialogs, drawers)
Overlay:  shadow-2xl (full-screen sheets)
```

### Skeleton loading pattern

```html
<!-- Replace content with animated placeholders while loading -->
<div class="animate-pulse space-y-3">
  <div class="h-4 bg-gray-200 rounded w-3/4"></div>
  <div class="h-4 bg-gray-200 rounded w-1/2"></div>
  <div class="h-10 bg-gray-200 rounded"></div>
</div>
```

### Optimistic UI

Update the UI immediately on user action, revert on error:

```elixir
# 1. Flip state instantly (user sees immediate feedback)
# 2. Perform server operation
# 3. On error: revert state + show error flash
```

## References

- **[animation-patterns.md](references/animation-patterns.md)**: CSS/Tailwind animation recipes, LiveView JS transitions, loading states, spring physics, staggered lists, micro-interaction examples
- **[component-patterns.md](references/component-patterns.md)**: Layout principles, density tiers, card/form/empty state patterns, color system, touch targets, onboarding patterns
- **[review-checklist.md](references/review-checklist.md)**: Systematic UI/UX review checklist — Nielsen's heuristics, visual hierarchy, feedback, spacing, responsive, animation, accessibility, polish
