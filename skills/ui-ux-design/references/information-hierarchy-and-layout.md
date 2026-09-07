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

The ordinary path should be understandable from the title, current state,
persistent labels, controls, and sequence. Do not make completion depend on an
instructional paragraph when the interface can communicate the decision
directly. People often scan before reading, but do not turn that observation
into the absolute claim that nobody reads.

Visible helper copy earns space when it prevents a likely error, explains a
non-obvious consequence, format, unit, scope, or recovery path, or supplies
necessary safety, legal, or trust context. Otherwise remove it, shorten it, or
reveal it when its condition occurs. Preserve persistent labels, accessible
names and descriptions, status, explicit alternatives, and error recovery. A
placeholder is not a label.

Required provider, license, or legal attribution is context, not task status.
Keep it visible and perceivable at the prominence its obligation requires, but
place it outside success, error, loading, and confirmation messages unless the
attribution itself changes the user's decision. Do not hide required credit;
do not let it masquerade as operational feedback or compete with the next
action.

Prefer one immediate job or decision per focused screen. Use progress-marked
steps only when each step is independently understandable and splitting does
not remove comparison context, increase backtracking, or make completion and
recovery harder. A complex comparison, safety decision, or tightly coupled set
of fields can be clearer on one well-structured screen than across ceremonial
steps.

## Match composition to the surface

| Surface | Composition priority |
| --- | --- |
| Acquisition/marketing | Value, differentiation, credible proof, one primary action, SEO/share context |
| Onboarding | Time to first useful outcome, progress, safe defaults, escape and recovery |
| Internal task | Information utility, local status, direct actions, predictable navigation |
| Admin/data-heavy | Scanability, filtering, comparison, bulk safety, audit and recovery |

Do not stack acquisition chrome and operational action bars in one focused
journey.

Treat authentication as an operational task once a person chooses a method or
a challenge is issued. Remove acquisition and trust storytelling from those
follow-up screens; keep only destination or status, credential, primary action,
and compact recovery. On small screens, use the page surface directly instead
of nesting the flow in a bordered or elevated card. Wide screens may add subtle
containment without changing the hierarchy.

When one account task supports several authentication methods, choose one
contextual primary method only when it is actually available. Expose its usable
control directly; a prominent method-selection link beside an exposed secondary
input does not establish the intended hierarchy. Keep the next viable method
recognizable and reveal specialist credentials progressively. An explicit
method choice overrides the default; reauthentication uses only methods
verified for that account. Do not make several equal-looking submit buttons
compete or use a regional hint as proof of the preferred identity method.

When observed users leave a task to look up an unfamiliar identifier, consider
an explicit, editable suggestion path from context they can provide. Preserve
manual entry and distinguish a suggested value from a confirmed fact. Device
context need not describe the destination or subject of the task.

Observe an uncoached first action before adding instructions. Record completion,
recovery, and requests for help; automated visibility checks cannot establish
improved comprehension or conversion. These reviewed form-entry decisions are
retained as the project-neutral `form-entry-2026-09-06` revision; downstream
adoption requires review rather than automatic synchronization.

## Use space and width intentionally

Assign horizontal padding to one owner. Use a full-width background band with
an inner content container when a landing page needs breadth. Keep prose to a
readable measure while allowing grids, media, maps, and comparisons to use more
horizontal space.

On compact task pages, audit effective width as a stack: viewport gutter,
container border, container padding, and child padding. Keep one content gutter
instead of nesting independently padded cards. A background, divider, or list
surface can bleed through that gutter while its text and controls stay aligned
to the safe content edge. Keep an inset card only when it communicates a real
object, selection, or independent action boundary.

When peer filters do not fit, prefer one labelled, natively scrollable
horizontal rail. Leave a partial next item or another truthful continuation cue
visible, reserve space for focus and selected states, and prevent document-level
overflow. Prove the geometry at a compact boundary and again at a wide
viewport; do not encode the acceptance test as a particular CSS class.

Audit useful vertical task area as well as reflow. Account for persistent
navigation, route context, section navigation, and action bars. Consolidate
repeated headings, status, identity, and secondary actions so the task and its
first useful control appear early. Do not impose an arbitrary viewport
percentage; judge whether the person can identify and begin the job without
scrolling through explanation or duplicated chrome.

Treat a repeated-entity management page as an index unless its primary job is
explicitly analytical. Each item needs identity, the most important actionable
state, one primary destination, and compact secondary access. Render parent
context and parent-scoped actions once per group. Move metrics, setup detail,
and advanced configuration into focused destinations instead of repeating
them in every item. A completed item can use a calm textual state; it does not
need another competing call to action. Single-object detail pages and urgent
states may expose more when that information directly changes the next task.

The parent owns external spacing and relationships; components own internal
padding. Use density variants only when the task context truly differs.

## Structure implementation by responsibility

Keep a page's top-level implementation readable as an outline of the user
journey. Extract a cohesive task, domain section, repeated semantic contract,
or complex data-to-view transformation when that boundary makes purpose,
inputs, states, and tests clearer. Cross-page reuse is useful evidence, but it
is not the only reason to create a component.

Do not split by an arbitrary line count. Avoid components that merely rename a
small fragment, accept most of the parent's state, hide data access, or force a
reader to chase many files to understand one decision. The parent should own
route-level orchestration and relationships; a component should own one
cohesive presentation or interaction contract; domain rules should remain in
their authoritative layer. Test stable behavior at those boundaries rather
than private markup structure.

## Design tokens

Centralize shared semantic decisions: surfaces, text roles, actions, status,
focus, spacing rhythm, radii, elevation, typography, and motion. Keep primitive
values separate from semantic meaning when multiple themes/platforms need it.
Do not tokenize one-off decoration or duplicate a value that already has a
clear owner.

Measure contrast in actual state combinations. Color names and perceptual color
spaces do not guarantee accessibility.
