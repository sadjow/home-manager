# Claude Code Integration

The module `home/claude-code.nix`:

1. Creates a stable wrapper at `~/.local/bin/claude` that prevents permission resets and passes
   `--allow-dangerously-skip-permissions`, so bypass permissions mode stays selectable with
   Shift+Tab even when a session starts in another `defaultMode`
2. Manages authored Claude configuration from `home/claude/`, including instructions, settings, agents, commands, and hooks
3. Leaves authentication, transcripts, projects, caches, downloaded plugins, and other runtime state writable under `~/.claude`
4. Preserves the mutable `~/.claude.json` file during Home Manager switches
5. Installs a command for each isolated profile in `home/claude/profiles.nix`

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

## Bypass Permissions Mode

Keep `pkgs.claude-code` out of `home.packages`. Home Manager appends `~/.local/bin` to
`PATH` after `~/.nix-profile/bin`, so a profile copy of the binary shadows the wrapper and
sessions started with plain `claude` lose the bypass option. Claude Code offers no settings
key or environment variable for this. The authored `permissions.defaultMode` is
`bypassPermissions`, so every session starts bypassed; the wrapper flag keeps the mode
selectable after switching to a stricter mode, and `skipDangerousModePermissionPrompt`,
which the CLI records once the warning dialog is accepted, stays in the runtime file.

The VS Code, Cursor, and Windsurf extensions launch their own bundled binary and read
`claudeCode.allowDangerouslySkipPermissions` from the editor's user settings instead.
Each activation sets it to `true` in those `settings.json` files through
`scripts/set-jsonc-setting.js`, which uses the pinned `jsonc-parser` from
`pkgs/jsonc-parser.nix` so comments, trailing commas, and layout survive. A file that
already has the value is left untouched; otherwise the previous contents are saved with
the suffix `.home-manager-backup`. Turning the setting off in an editor lasts until the
next switch.

## Known Issues Fixed

- **Permission Reset Issue**: Claude asked for directory permissions after every `home-manager switch` because the nix store path changed. The stable wrapper keeps the executable path consistent.
- **Settings Loss**: Login state and trusted directories are preserved across switches.
- **Configuration Drift**: Author-controlled Claude configuration has one versioned Home Manager source of truth.

## Skill Discovery

`home/agent-skills.nix` owns this configuration's links in `~/.claude/skills`
and in each isolated profile's `skills` directory.
Public skills resolve to the pinned `sadjow/skills` source in the Nix store;
private skills resolve directly to the local private checkout. Selected upstream
skills retain links to their installer-managed sources under `~/.agents/skills`.
The public and private links share their targets with the other configured clients.

See [Agent skills](../README.md#agent-skills) for the authoritative installation
paths, update workflow, verification, and migration recovery instructions. Skill
contents are maintained outside this Home Manager repository.

## Isolated Profiles

Each entry under `isolated` in `home/claude/profiles.nix` installs a command that runs the stable wrapper with `CLAUDE_CONFIG_DIR` set to its directory, for example `claude-stackbuilders` with `~/.claude-stackbuilders`. The profile signs in to its own account and keeps its own transcripts, project memory, plugins, and `.claude.json` state, while Home Manager installs the same instructions, settings, agents, commands, hooks, skills, and remote MCP servers as the default profile. Settings changed through `/config` stay in the profile where they were made.

Claude Code [keys the macOS Keychain entry to the configuration directory](https://code.claude.com/docs/en/authentication), so subscription logins in different profiles stay signed in at the same time. That separation does not cover Claude Console sign-ins without an API key, which are stored outside the configuration directory. The editor extensions launch their bundled binary and keep using the default profile.

`remoteControlAtStartup: true` in `home/claude/settings.json` connects each interactive session to [Remote Control](https://code.claude.com/docs/en/remote-control) in every profile. A Team or Enterprise organization can publish its own default, which Claude Code stores under `defaults` in the profile's `policy-limits.json`; an explicit user-scope value outranks that default but not an organization lock or `disableRemoteControl`. Only `settings.json` can turn auto-connect on; a `false` in `settings.local.json` or a project's `.claude/settings.json` turns it off for that scope.

After the first switch that adds a profile, run its command, such as `claude-spireworks` or `claude-stackbuilders`, sign in with `/login`, and confirm with `/status` that the account is the expected one and with `/memory` that the global instructions load once.

## Subagent Models and Effort

`CLAUDE_CODE_SUBAGENT_MODEL` makes Opus the default for subagents, agent-team teammates, and workflow agents that are not assigned a model another way. A model passed when Claude spawns an agent and an agent's `model` field, including `inherit`, take precedence; the built-in Explore and Plan agents keep following the session model. See the [subagent model order](https://code.claude.com/docs/en/sub-agents#choose-a-model).

The `opus` alias tracks the current Opus release line, the same way the session `model` does, so both move together on a Claude Code update. The bounded implementation agents leave `model` unset so the default applies, and set `effort: medium`, which overrides the `xhigh` that `modelSettings` declares for Opus in the main session; an unset `effort` would inherit the session level. The review and harness agents set `model: inherit` so judgment-heavy work stays on the session model.

Cursor also loads `~/.claude/agents`. It defaults `model` to `inherit` and does not document `effort`, so keep Cursor-only syntax, such as bracketed model parameters, out of these shared files.

Top-level `effortLevel` reaches only Opus 5, Fable 5.1, and earlier models, and a `modelSettings` entry overrides it, so `modelSettings` declares the effort for current models ([settings reference](https://code.claude.com/docs/en/settings-reference)). `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` affects only Opus 4.6 and Sonnet 4.6 and stays unset. `/tasks` shows the model each subagent ran on, and its effort when the definition sets one.

## Context Budget

Always-loaded context is deliberately small. `home/AGENTS.md` loads into every Claude Code and Codex session, and `scripts/check-agent-instructions`, which runs in `nix flake check`, holds it to a word budget. The budget is a chosen review point, not a client limit: Claude Code recommends keeping each instruction file [under 200 lines](https://code.claude.com/docs/en/memory), and Codex reads the global `~/.codex/AGENTS.md` in full, outside the `project_doc_max_bytes` cap that bounds repository instruction files. Studies found that context files do not measurably improve task success ([Gloaguen et al.](https://arxiv.org/abs/2602.11988), [Khatri](https://arxiv.org/abs/2607.27250)) while raising inference cost by over 20% in the first, although agents follow their instructions well; adherence also degrades as instructions accumulate and favors earlier ones ([IFScale](https://arxiv.org/abs/2507.11538)). The file therefore keeps authority, safety, and non-standard practices that no skill or check owns, with authority and safety first. When the check fails, remove guidance that a skill or check already owns, move conditional guidance into a skill, or raise the budget in the same commit with its reason. The budget covers only this file; project instructions, memory, and the skill listing also load in every session, so compare the whole first-turn prompt with the measurement below.

`home/claude/settings.json` caps each skill listing entry with `skillListingMaxDescChars` and lists skills that are only ever invoked by name as `name-only` through `skillOverrides`, so the listing stays under `skillListingBudgetFraction`. When the listing still exceeds the budget, Claude Code silently drops descriptions starting with the least-used skills, so an important skill can lose its routing text without any warning; `/context` shows the listing size and `/skill-doctor` shows which skills cost most.

Skills that a particular repository never needs belong in that repository's ignored `.claude/settings.local.json` as `"skillOverrides": {"<skill>": "off"}`, not in the global settings: personal skills stay available elsewhere and the project's own skills keep their descriptions. The same file takes `disabledMcpjsonServers` for a `.mcp.json` server the project does not use.

Measure the first-turn prompt from the project directory before and after a change:

```bash
claude -p 'Reply with exactly: ok' --model haiku --no-chrome --output-format json \
  | jq '.usage | .input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens'
```

Pass `--settings <file.json>` to try an override without applying it. Denying a built-in tool through `permissions.deny` does not remove it from the prompt; `enableWorkflows: false` does remove the Workflow tool. Agent frontmatter must be valid single-line YAML; an invalid file is skipped silently. Check with `/doctor` or `/skill-doctor`.
