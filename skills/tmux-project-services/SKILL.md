---
name: tmux-project-services
description: Start, inspect, reuse, and stop long-running local project services in tmux. Use for development servers, workers, watchers, and project supervisors that must survive an agent turn or terminal disconnect. Short tests and builds can run directly.
---

# Project Services in tmux

Keep long-running project services in a named tmux session so the user and later agents can find, attach to, and stop the same processes. tmux preserves the terminal across client disconnects; it does not prove service health or clean up every daemonized descendant.

## Choose the control interface

Use the native tmux CLI when shell execution is available. It provides structured status through `-F` formats and exact session and pane targets. Use `tmux -C` control mode only when an integration needs asynchronous terminal events. An MCP wrapper is optional for a client that needs MCP access; it must use the same project scope and authorization boundaries.

## Identify the worktree and existing services

1. Read the project's startup instructions and identify its foreground command, environment, ports, and shutdown procedure. Starting a project does not authorize deployment or unrelated jobs.
2. Resolve the actual project or worktree root. Run the following from that root. Its canonical path distinguishes checkouts with the same basename:

   ```bash
   project_root=$(pwd -P)
   project_slug=$(printf '%s' "$(basename "$project_root")" | tr -c '[:alnum:]_-' '-' | cut -c 1-32)
   project_hash=$(printf '%s' "$project_root" | shasum -a 256 | cut -c 1-12)
   project_session="dev-$project_slug-$project_hash"
   ```

3. Use that name for a dedicated socket (`-L`) and session (`-s`). A separate socket keeps each worktree's tmux environment and controls apart. Supply the socket on every command; never rely on whichever session is currently attached.
4. Check the exact session with `tmux -L "$project_session" has-session -t "=$project_session"`. Also inspect the project's process manager and listening ports for services started outside tmux. Reuse healthy services; do not launch duplicates or stop another project's listener to acquire a port.
5. If startup races with another agent, inspect and reuse the resulting session after verifying its worktree and service state. An existing name alone is not proof that the requested service is running.

## Start the foreground supervisor

After confirming that the intended session and services are absent, create the session with the startup executable and arguments directly. This avoids shell-input timing and quoting errors from typing a startup command with `send-keys`.

For a project managed by devenv:

```bash
tmux -L "$project_session" -f /dev/null new-session \
  -d -s "$project_session" -n services -c "$project_root" \
  -P -F '#{session_name} #{pane_id}' \
  -- devenv up
```

`-f /dev/null` applies a predictable configuration to this dedicated server without changing the user's personal tmux configuration. Record the returned pane ID. A process that exits immediately may also remove the session; report the failed startup instead of repeatedly creating sessions.

Keep the project supervisor in the foreground inside the detached tmux session. For devenv, use `devenv up` here; do not add `-d`, `nohup`, or a trailing `&`. Preserve other project-required options supported by the installed version. If a project requires direnv setup before devenv, use `direnv exec "$project_root" devenv up` as the startup arguments.

For individual services, enter the declared environment inside the pane command, such as `devenv shell -- <service-command>` or `direnv exec "$project_root" <service-command>`. A noninteractive pane does not reliably execute interactive shell hooks. Additional service windows belong to the same worktree session. Keep short commands outside tmux unless their task requires a persistent terminal.

Honor explicit user choices and platform constraints. Do not wrap an existing container or operating-system service manager unnecessarily. If tmux is unavailable, report that fact and use the project's existing supported lifecycle when authorized; do not change the global environment silently.

## Verify readiness and hand off

Inspect only the owned session's metadata:

```bash
tmux -L "$project_session" list-panes -s -t "=$project_session" \
  -F '#{pane_id} pid=#{pane_pid} cwd=#{pane_current_path} command=#{pane_current_command} dead=#{pane_dead}'
```

Verify the worktree, supervisor status, and a project-defined readiness probe. A live pane or open port alone is insufficient. Use read-only health checks that do not create application data, and keep waits bounded.

Pane output is a log surface. Do not dump scrollback, environment variables, or full command lines that may contain credentials. Prefer readiness/status metadata; inspect a narrowly selected, redacted output projection only when diagnosis needs it. Pass secrets through the project's existing secret provider without typing or echoing them into terminal commands.

Give the user the project path, session name, readiness result, and exact attach command:

```bash
tmux -L "$project_session" attach-session -t "=$project_session"
```

Explain that `Ctrl+b`, then `d` detaches while services continue. Substitute the actual session name in the handoff so the command works in a fresh terminal.

## Stop and restart safely

1. Recheck the session's worktree, pane IDs, and service ownership before stopping anything. Preserve other worktrees, personal sessions, and agent tool processes.
2. Use the project's documented shutdown command from its worktree, or send `C-c` to the verified foreground pane with `tmux -L "$project_session" send-keys -t "$service_pane" C-c`. Obtain `service_pane` from the metadata check first. For devenv, inspect the installed `devenv processes --help`; do not assume a top-level `devenv down` command exists.
3. Wait for the documented shutdown interval and verify that owned workers and listeners have exited. A stopped tmux pane or process manager does not establish that descendants stopped. Give databases their native graceful shutdown path.
4. If processes remain, identify them by project directory, process ancestry, and executable before signaling exact PIDs. Use normal termination first, then force only confirmed stuck processes within the authorized scope. Never use broad name-based process kills or an unscoped `tmux kill-server`.
5. Remove a remaining owned session with `tmux -L "$project_session" kill-session -t "=$project_session"` after service shutdown is verified. Restart only when requested, then rerun readiness checks.

## References

- [tmux manual](https://man.openbsd.org/tmux.1): direct command arguments, socket selection, formatted status, and exact targets.
- [tmux control mode](https://github.com/tmux/tmux/wiki/Control-Mode): the native text protocol and asynchronous events.
