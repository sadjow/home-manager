# Upstream skill sources

Keep vendor and update notes here, outside each skill directory. This keeps the
local skill package easy to compare with its upstream source.

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
