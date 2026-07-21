# Harness Smells

Read this reference when auditing, pruning, or modifying accumulated instructions, rules, skills, agents, hooks, or related configuration.

## Inspect high-value smells

| Smell | Evidence | Repair |
| --- | --- | --- |
| Context bloat | Large always-loaded files contain low-priority or task-specific detail | Keep a concise map and move conditional detail behind scoped references or skills |
| Skill leakage | Specialized workflows appear in global instructions | Move the workflow into an on-demand skill with precise triggering metadata |
| Lint leakage | Prose repeats formatter, linter, schema, or compiler rules | Configure the deterministic tool and keep only its canonical command discoverable |
| Blind reference | A path is listed without explaining when or why to read it | Add a meaningful routing condition or remove the reference |
| Duplicate knowledge | The same rule is copied across vendor files and documentation | Select one source of truth and use thin adapters |
| Conflicting scope | Parent, nested, personal, or vendor rules disagree | Resolve ownership and keep the most local legitimate rule explicit |
| Init fossilization | Generated guidance was never revisited after setup | Revalidate against current tasks and remove obsolete scaffolding |
| Append-only growth | Every failure adds text but nothing is replaced or removed | Diagnose the layer, consolidate, and prune superseded controls |
| Vague quality language | Guidance says “clean,” “robust,” or “best practice” without a project decision | Replace it with a concrete invariant, example, rubric, or executable check |
| Hidden environment state | Success depends on undeclared services, credentials, caches, or prior runs | Add a canonical bootstrap, reset path, or explicit prerequisite |
| Unverifiable completion | The harness accepts an agent statement as proof | Require outcome evidence such as tests, runtime inspection, or artifacts |
| Reviewer swarm | Every change invokes many overlapping agents | Route review by risk and use one bounded independent reviewer when justified |
| Broad authority | Tools receive ambient credentials, network access, or write scope | Apply least privilege, isolation, allowlists, and human checkpoints |
| Stale memory | Raw transcripts or old conclusions are loaded into unrelated tasks | Retain compact evidence-linked decisions and retrieve them by relevance |

## Audit in a useful order

1. Inventory instruction entry points, scoped rules, skills, agents, hooks, scripts, CI checks, permissions, state artifacts, and observability surfaces.
2. Identify which files are canonical, generated, linked, personal, or vendor-specific.
3. Measure size and overlap before judging context cost.
4. Verify that documented commands work from their stated directory and prerequisites.
5. Trace representative feedback to the mechanism intended to prevent recurrence.
6. Check whether deterministic requirements are executable.
7. Check whether high-impact actions require appropriate authority.
8. Remove or consolidate one mechanism at a time and replay representative tasks.

Do not create a numeric harness score without validated weights. Report each area as verified, present but unverified, missing, blocked, or not applicable, with supporting evidence.

## Prune safely

Treat every harness component as an assumption about what agents and the project need. Model, tool, architecture, and workflow changes can invalidate that assumption.

Before removing a component:

- identify the outcome it was meant to protect
- find the original evidence or current representative task
- check whether another mechanism now owns the same responsibility
- remove the smallest independent unit
- replay the protected task and nearby regressions

Keep the component when its value remains load-bearing. Rewrite it when the responsibility is sound but its location or enforcement layer is wrong. Remove it when the project retains the outcome without it.
