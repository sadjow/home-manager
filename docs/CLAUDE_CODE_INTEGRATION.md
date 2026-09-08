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

Always-loaded context is deliberately small. `home/claude/settings.json` caps each skill listing entry with `skillListingMaxDescChars` and lists rarely used skills name-only through `skillOverrides`, so the listing stays under `skillListingBudgetFraction` and no description is silently dropped. Measure with a headless run:

```bash
claude -p 'Reply with exactly: ok' --model haiku --debug-file /tmp/claude-debug.txt --no-chrome
grep 'Skill listing over budget' /tmp/claude-debug.txt
```

No output means every listed description fits. Agent frontmatter must be valid single-line YAML; an invalid file is skipped silently. Check with `/doctor` or `/skill-doctor`.
