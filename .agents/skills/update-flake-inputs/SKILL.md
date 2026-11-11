---
name: update-flake-inputs
description: Update flake inputs in this Home Manager repository, apply the new configuration, check it, then commit and push `flake.lock`. Use for requests such as "update claude and codex" or "update the skills input". With no input named, it updates `claude-code` and `codex-cli`.
---

# Update Flake Inputs

Move the requested flake inputs to their latest revisions and finish the job:
the new Home Manager generation is active, the flake checks pass, and
`flake.lock` is on `origin/main`. Invoking this skill is the request to commit
`flake.lock` and push it to `main`.

The inputs are the flake input names given with the request, as declared in
`flake.nix`. When none are given, update `claude-code` and `codex-cli`.

## Steps

Keep this order, so that the commit records a configuration that was checked
and applied.

1. **Start from the published state.** Require branch `main` with no
   uncommitted changes to tracked files, then run `git pull --ff-only`.
   `home-manager switch --flake .` also activates uncommitted changes to
   tracked files, so when there are any, stop and report which files they are
   instead of stashing or activating them.
2. **Record the installed versions** of the tools the inputs provide:
   `claude --version` for `claude-code` and `codex --version` for `codex-cli`.
3. **Update the pins** with `nix flake update <input> [<input> ...]` and keep
   the old and new revision lines it prints. When `flake.lock` is unchanged,
   the inputs were already current: report that and stop.
4. **Check, then apply:** `nix flake check`, then
   `home-manager switch --flake .`.
5. **Confirm the installed versions** with the commands from step 2.
6. **Commit and push only the lock file**, naming the inputs that changed:

   ```sh
   git commit -m "chore(flake): update the claude-code and codex-cli inputs" -- flake.lock
   git push origin main
   git status -sb
   ```

   The last command must show `main` level with `origin/main`.

## When a step fails

Do not commit or push. Report the failing step with its error, and leave
`flake.lock` modified so the failure can be reproduced; `git restore flake.lock`
returns to the previous pins. A switch that failed part-way can already have
applied some changes, so say whether the switch ran. When the push is rejected,
report the rejection and leave the commit in place; never force-push.

## Report

For each input, give the old and new version, or the old and new revision date
when the input provides no versioned tool. Give the commit and confirm that it
is on `origin/main`. A Claude Code or Codex session that is already running
keeps its old version; the new version starts with the next session.
