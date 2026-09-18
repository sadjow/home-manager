# Claude Code Home Manager Sources

Home Manager owns the author-controlled Claude Code configuration in this directory.

Managed paths include global instructions, settings, agents, commands, and hooks. Skill installation belongs to `home/agent-skills.nix`, which consumes the public skills repository and links locally available private skills.

`settings.json` and `settings.local.json` are installed as writable files with mode
`600`, so Claude can save model selections and other preferences. On first
activation, repository settings take precedence over existing settings; additional
runtime keys are retained. Later activations compare the repository settings with
the last applied baseline: unchanged fields retain Claude's edits, while changed
or removed repository fields take effect. Objects merge recursively; arrays are
treated as whole values. Deleting a runtime file restores repository defaults.

The baseline in `~/.claude/.home-manager-settings/` is generated from these sources;
edit the repository files to change declared settings. Before replacing an existing
runtime file, activation saves its previous contents beside it with the suffix
`.home-manager-backup`. Runtime settings and backups stay outside the Nix store.

Claude Code continues to own mutable application data such as authentication, transcripts, project memory, caches, plugin downloads, file history, jobs, sessions, and daemon state.

Do not put credentials or tokens in these files. Home Manager can copy managed sources into the world-readable Nix store.
