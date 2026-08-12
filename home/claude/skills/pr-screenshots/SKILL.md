---
name: pr-screenshots
description: >-
  Attach screenshots to GitHub PRs by opening image files in macOS Preview for
  drag-and-drop. Use when posting PR comments that reference screenshots,
  EmailOnAcid results, UI comparisons, or any visual evidence that needs to be
  attached to a PR or issue.
---

# PR Screenshots

## Workflow

When attaching screenshots to a GitHub PR:

1. **Post the PR comment first** with a placeholder for images:

```bash
gh pr comment <PR_NUMBER> --body "$(cat <<'EOF'
## Title

Description and results table.

_Drag-and-drop screenshots here_
EOF
)"
```

2. **Open all screenshots in macOS Preview** so the user can drag-and-drop them into the GitHub comment:

```bash
open /path/to/screenshot1.png /path/to/screenshot2.png /path/to/screenshot3.png
```

3. **Tell the user** the screenshots are open in Preview and ready to drag into the PR comment.

## Key Details

- Always post the comment first, then open images. This way the user has both the browser tab and Preview ready.
- Use `open` (macOS) to launch Preview with all images at once.
- GitHub doesn't support image uploads via `gh` CLI, so drag-and-drop from Preview is the practical solution.
- When multiple screenshots exist in different directories, list all full paths in a single `open` command.
- Mention the file paths in the response so the user can find them if Preview doesn't come to the foreground.
