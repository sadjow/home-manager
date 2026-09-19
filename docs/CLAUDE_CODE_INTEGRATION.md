# Claude Code Integration

The module `home/claude-code.nix`:

1. Creates a stable wrapper at `~/.local/bin/claude` to prevent permission resets
2. Manages authored Claude configuration from `home/claude/`, including instructions, settings, agents, commands, and hooks
3. Leaves authentication, transcripts, projects, caches, downloaded plugins, and other runtime state writable under `~/.claude`
4. Preserves the mutable `~/.claude.json` file during Home Manager switches

See `home/claude/README.md` for the managed and runtime ownership boundary.

## Instruction Discovery

The repository's [AGENTS.md](../AGENTS.md) owns shared project guidance. Claude Code
2.1.277 was verified to load it directly with the default
`claude-md-or-agents-md` setting. Keep the repository root free of a `CLAUDE.md`
alias, which would take precedence over native AGENTS.md discovery. See the
[release notes](https://github.com/anthropics/claude-code/releases/tag/v2.1.277)
for provider availability.

Global instructions remain in `home/AGENTS.md`, linked at `~/AGENTS.md` and
`~/.codex/AGENTS.md`. The global `~/.claude/CLAUDE.md` imports `~/AGENTS.md` and adds
Claude-specific guidance from `home/claude/CLAUDE.md`. This user-scope import
remains necessary independently of project-file discovery. In a fresh Claude
session, confirm the startup message reports `AGENTS.md loaded` and use `/memory`
to verify the global import appears once. In 2.1.277, `/memory` still labels its
project entry `CLAUDE.md`; that label does not reflect native AGENTS.md discovery.

## Known Issues Fixed

- **Permission Reset Issue**: Claude asked for directory permissions after every `home-manager switch` because the nix store path changed. The stable wrapper keeps the executable path consistent.
- **Settings Loss**: Login state and trusted directories are preserved across switches.
- **Configuration Drift**: Author-controlled Claude configuration has one versioned Home Manager source of truth.

## Skill Discovery

`home/agent-skills.nix` owns this configuration's links in `~/.claude/skills`.
Public skills resolve to the pinned `sadjow/skills` source in the Nix store;
private skills resolve directly to the local private checkout. Selected upstream
skills retain links to their installer-managed sources under `~/.agents/skills`.
The public and private links share their targets with the other configured clients.

See [Agent skills](../README.md#agent-skills) for the authoritative installation
paths, update workflow, verification, and migration recovery instructions. Skill
contents are maintained outside this Home Manager repository.

## Context Budget

Always-loaded context is deliberately small. `home/claude/settings.json` caps each skill listing entry with `skillListingMaxDescChars` and lists skills that are only ever invoked by name as `name-only` through `skillOverrides`, so the listing stays under `skillListingBudgetFraction`. When the listing still exceeds the budget, Claude Code silently drops descriptions starting with the least-used skills, so an important skill can lose its routing text without any warning; `/context` shows the listing size and `/skill-doctor` shows which skills cost most.

Skills that a particular repository never needs belong in that repository's ignored `.claude/settings.local.json` as `"skillOverrides": {"<skill>": "off"}`, not in the global settings: personal skills stay available elsewhere and the project's own skills keep their descriptions. The same file takes `disabledMcpjsonServers` for a `.mcp.json` server the project does not use.

Measure the first-turn prompt from the project directory before and after a change:

```bash
claude -p 'Reply with exactly: ok' --model haiku --no-chrome --output-format json \
  | jq '.usage | .input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens'
```

Pass `--settings <file.json>` to try an override without applying it. Denying a built-in tool through `permissions.deny` does not remove it from the prompt; `enableWorkflows: false` does remove the Workflow tool. Agent frontmatter must be valid single-line YAML; an invalid file is skipped silently. Check with `/doctor` or `/skill-doctor`.
