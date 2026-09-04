# Upstream skill sources

Keep vendor and update notes here, outside each skill directory. This keeps the
local skill package easy to compare with its upstream source.

## `browser-harness`

| Field | Value |
|---|---|
| Local path | `skills/browser-harness/` |
| Upstream | <https://github.com/browser-use/browser-harness> |
| Release | [`v0.1.10`](https://github.com/browser-use/browser-harness/releases/tag/v0.1.10) |
| Imported commit | [`6bb1c847fd62638554618e8d1e03247b935ff9cf`](https://github.com/browser-use/browser-harness/commit/6bb1c847fd62638554618e8d1e03247b935ff9cf) |
| Imported on | 2026-09-03 |
| License | MIT |
| Import scope | Root `SKILL.md` and `LICENSE` |
| Runtime owner | `home/browser-harness.nix` pins the matching PyPI CLI |
| Local adaptation | Discovery description, `Tool selection` section, and [local Codex routing adapter](browser-harness/references/codex-computer-use.md), maintained by the personal Home Manager harness |

### Refresh procedure

1. Resolve the latest stable release and its commit from GitHub and PyPI.
2. Download that exact commit into a temporary review directory:

   ```sh
   review_root="$(mktemp -d)"
   python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
     --repo browser-use/browser-harness \
     --path . \
     --ref <commit> \
     --dest "$review_root" \
     --name browser-harness
   ```

3. Compare its root `SKILL.md` and `LICENSE` with `skills/browser-harness/`.
4. Merge reviewed upstream changes into the local copy, preserving the local
   adaptation above. Do not replace it wholesale with upstream `SKILL.md` or
   `browser-harness skill` output. Update the release, imported commit, import
   date, and `browserHarnessVersion` in `home/browser-harness.nix`.
5. Run `home-manager build --flake .` to verify the package and managed links.

## `asd-ste100`

| Field | Value |
|---|---|
| Local path | `skills/asd-ste100/` |
| Upstream | <https://github.com/danyuchn/asd-ste100-skill> |
| Branch | `master` |
| Imported commit | [`8564f8985f15104c2184f90531bfd1bbb25f3d5b`](https://github.com/danyuchn/asd-ste100-skill/commit/8564f8985f15104c2184f90531bfd1bbb25f3d5b) |
| Imported on | 2026-08-05 |
| License | MIT |
| Import scope | Full repository contents, excluding Git metadata |

### Refresh procedure

1. Read the current upstream commit without changing the local copy:

   ```sh
   git ls-remote https://github.com/danyuchn/asd-ste100-skill.git refs/heads/master
   ```

2. Download that exact commit into a temporary review directory:

   ```sh
   review_root="$(mktemp -d)"
   python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
     --repo danyuchn/asd-ste100-skill \
     --path . \
     --ref <commit> \
     --dest "$review_root" \
     --name asd-ste100
   ```

3. Review the upstream changes before applying them:

   ```sh
   diff -ru skills/asd-ste100 "$review_root/asd-ste100"
   ```

4. Apply only the reviewed changes to `skills/asd-ste100/`. Then update the
   imported commit and date above.
5. Run `home-manager build --flake .` to verify the updated copy and its links.

## `playwright-best-practices`

| Field | Value |
|---|---|
| Installed name | `playwright-best-practices` |
| Upstream | <https://github.com/currents-dev/playwright-best-practices-skill> |
| Imported commit | [`ef329e7e65149918e1ff0eed2cf7d2e6e6f9eb5b`](https://github.com/currents-dev/playwright-best-practices-skill/commit/ef329e7e65149918e1ff0eed2cf7d2e6e6f9eb5b) |
| Installed on | 2026-04-25 |
| Ownership | External general-purpose dependency managed by `home/claude-code.nix` |

Keep this package intact. `playwright-reactive-ux-testing` is an authored,
narrow specialization for temporal and recovery boundaries in reactive UIs;
it does not replace or vendor the upstream package.
