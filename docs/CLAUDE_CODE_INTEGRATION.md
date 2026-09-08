# Claude Code Integration

The module `home/claude-code.nix`:

1. Creates a stable symlink at `~/.local/bin/claude` to prevent permission resets
2. Manages authored Claude configuration from `home/claude/`, including instructions, settings, agents, commands, hooks, and locally maintained skills
3. Links shared skills from their canonical agent-skill sources
4. Leaves authentication, transcripts, projects, caches, downloaded plugins, and other runtime state writable under `~/.claude`
5. Preserves the mutable `~/.claude.json` file during Home Manager switches

See `home/claude/README.md` for the managed and runtime ownership boundary.

## Known Issues Fixed

- **Permission Reset Issue**: Claude asked for directory permissions after every `home-manager switch` because the nix store path changed. The stable symlink fixes this.
- **Settings Loss**: Login state and trusted directories are preserved across switches.
- **Configuration Drift**: Author-controlled Claude configuration has one versioned Home Manager source of truth.

## Skill Discovery

Claude Code discovers user skills only in `~/.claude/skills`. The links that `home.nix` and `home/claude-code.nix` place there point at `skills/` in this repository or at `~/.agents/skills`, the canonical store shared with other agents, so one skill on disk is loaded once. The debug log line `Loading skills from:` shows the scanned directories, and `Loaded N unique skills` shows the result.

## Context Budget

Always-loaded context is deliberately small. `home/claude/settings.json` caps each skill listing entry with `skillListingMaxDescChars` and lists skills that are only ever invoked by name as `name-only` through `skillOverrides`, so the listing stays under `skillListingBudgetFraction`. When the listing still exceeds the budget, Claude Code silently drops descriptions starting with the least-used skills, so an important skill can lose its routing text without any warning; `/context` shows the listing size and `/skill-doctor` shows which skills cost most.

Skills that a particular repository never needs belong in that repository's ignored `.claude/settings.local.json` as `"skillOverrides": {"<skill>": "off"}`, not in the global settings: personal skills stay available elsewhere and the project's own skills keep their descriptions. The same file takes `disabledMcpjsonServers` for a `.mcp.json` server the project does not use.

Measure the first-turn prompt from the project directory before and after a change:

```bash
claude -p 'Reply with exactly: ok' --model haiku --no-chrome --output-format json \
  | jq '.usage | .input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens'
```

Pass `--settings <file.json>` to try an override without applying it. Denying a built-in tool through `permissions.deny` does not remove it from the prompt; `enableWorkflows: false` does remove the Workflow tool. Agent frontmatter must be valid single-line YAML; an invalid file is skipped silently. Check with `/doctor` or `/skill-doctor`.
