# Vendor Adapters

Read this reference only when guidance must be distributed across multiple agent products or a vendor-specific instruction format.

Vendor behavior changes. Inspect the repository's current configuration and verify the targeted product's current discovery rules before relying on these patterns.

## Preserve one source of truth

Keep shared project knowledge in canonical, versioned repository documentation. Make each vendor entry point a concise router, import, link, or mechanically generated adapter.

Prefer adapter strategies in this order:

1. Direct import from the canonical source
2. Managed symbolic link
3. Generated adapter with a drift check
4. Small vendor-specific file containing only genuinely product-specific behavior

Do not manually copy the same rule into several files.

A prose sentence that tells an agent to follow another file is not equivalent to a verified import. When the product supports inclusion, use its actual inclusion syntax.

Claude Code currently supports `@path` imports. When `AGENTS.md` is canonical, prefer this minimal `CLAUDE.md` after verifying the installed product still supports it:

```markdown
@AGENTS.md
```

For Cursor and Copilot, support differs across IDE, CLI, review, and cloud-agent surfaces. Do not create a pointer file when the targeted surface already discovers the canonical file. Otherwise, use that surface's supported file reference or scoped adapter and verify it loads.

## Route common surfaces

| Product surface | Typical role |
| --- | --- |
| `AGENTS.md` and nested variants | Vendor-neutral project map and scoped repository guidance |
| `CLAUDE.md` and `.claude/rules/` | Claude-specific import, activation, or path-scoped guidance |
| `.cursor/rules/` | Cursor-specific activation and scoped rules |
| `.github/copilot-instructions.md` and `.github/instructions/` | Copilot repository-wide and path-scoped guidance |
| Project skill directories | On-demand reusable workflows |
| Product settings and hooks | Vendor-specific permissions or lifecycle integration |

Support varies across IDE, CLI, review, and cloud-agent surfaces. Confirm that the intended surface actually loads the chosen file.

## Separate portable knowledge from adapters

Keep these portable where possible:

- project purpose and architecture boundaries
- canonical setup, build, test, and lint entry points
- definitions of done and verification evidence
- security boundaries and protected actions
- links to scoped documentation and reusable skills

Keep these vendor-specific:

- activation metadata and path matching
- hook event schemas
- permission configuration
- tool or MCP declarations
- product-only commands and diagnostics

Do not hide business rules or architectural invariants exclusively inside a vendor adapter.

## Validate distribution

After changing an adapter:

1. Confirm the canonical target exists.
2. Confirm imports, links, or generated files resolve correctly.
3. Check that the relevant product loads the rule at the intended scope.
4. Check precedence against parent, nested, personal, and override instructions.
5. Measure always-loaded content when token reduction is part of the claim.
6. Add a drift check when generation or unavoidable duplication is used.

Edit the declarative or generated source rather than a managed target. Preserve unrelated personal configuration and do not assume that a successful link proves the product consumed the content.
