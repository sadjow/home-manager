# Claude Code Home Manager Sources

Home Manager owns the author-controlled Claude Code configuration in this directory.

Managed paths include global instructions, settings, agents, commands, hooks, and locally maintained skills. Shared skills can be linked from their canonical source by `home/claude-code.nix`.

Claude Code continues to own mutable application data such as authentication, transcripts, project memory, caches, plugin downloads, file history, jobs, sessions, and daemon state.

Do not put credentials or tokens in these files. Home Manager can copy managed sources into the world-readable Nix store.
