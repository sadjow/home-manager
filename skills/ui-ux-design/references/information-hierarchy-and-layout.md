# Information hierarchy and layout

## Start from the job

For each surface, write:

- the person and immediate job;
- the primary decision/action;
- the minimum context needed to act safely;
- secondary details that can be deferred;
- success, empty, error, and recovery states.

Order content by that mental model, not by database schema or component
availability. Recognition is usually cheaper than recall; show useful choices
and current state rather than expecting memory.

## Match composition to the surface

| Surface | Composition priority |
| --- | --- |
| Acquisition/marketing | Value, differentiation, credible proof, one primary action, SEO/share context |
| Onboarding | Time to first useful outcome, progress, safe defaults, escape and recovery |
| Internal task | Information utility, local status, direct actions, predictable navigation |
| Admin/data-heavy | Scanability, filtering, comparison, bulk safety, audit and recovery |

Do not stack acquisition chrome and operational action bars in one focused
journey.

## Use space and width intentionally

Assign horizontal padding to one owner. Use a full-width background band with
an inner content container when a landing page needs breadth. Keep prose to a
readable measure while allowing grids, media, maps, and comparisons to use more
horizontal space.

The parent owns external spacing and relationships; components own internal
padding. Use density variants only when the task context truly differs.

## Design tokens

Centralize shared semantic decisions: surfaces, text roles, actions, status,
focus, spacing rhythm, radii, elevation, typography, and motion. Keep primitive
values separate from semantic meaning when multiple themes/platforms need it.
Do not tokenize one-off decoration or duplicate a value that already has a
clear owner.

Measure contrast in actual state combinations. Color names and perceptual color
spaces do not guarantee accessibility.
