---
description: Build read-only context for the current branch from its default-branch diff and linked work
---

Build context for the current branch against its default branch. This command is
read-only orientation. Do not review the change, search for defects, produce
findings, recommend fixes, run tests, modify project files, post comments, or
create subagents.

1. Inspect `git status`, the current branch, remotes, and
   `refs/remotes/origin/HEAD`. Use the remote default branch when available. Fall
   back to `origin/main`, then `origin/master`.
2. Fetch the current default branch and branch ref when network access is
   available. If fetch fails, continue with local refs and state that they can be
   stale.
3. Find the merge base. Read the branch commits, three-dot diff stat, changed-file
   list, and complete three-dot diff. Include staged, unstaged, and untracked work
   as separate local context.
4. Find the pull request for the current branch with `gh pr view`. If that fails,
   search open and closed pull requests for the head branch. Read its number,
   title, body, state, draft state, URL, base, head, merge commit, and linked
   issues. Do not read review comments unless the user asks for them.
5. Detect when the pull request already merged, including squash merges. State
   that status before describing the diff. Use the merged pull request and merge
   commit as the delivery source when a three-dot diff still shows changes that
   already landed.
6. Extract work references from the branch name, commit messages, pull request,
   and changed files. These can include Linear identifiers, GitHub issues, Monday
   links, OpenSpec changes, proposals, designs, tasks, or equivalent artifacts.
   Read available linked titles, descriptions, status, scope, and acceptance
   context through read-only tools. If access is unavailable, report the
   identifier or link without guessing its content.
7. Read changed intent documents that help explain the work, such as OpenSpec
   proposals, designs, task lists, specifications, ADRs, and deployment notes.
   Read implementation files only far enough to explain the behavior and main
   boundaries.
8. Return a compact orientation with:
   - branch, default branch, merge base, pull request, and delivery state;
   - the goal and reason for the work;
   - prior and intended behavior when the sources define them;
   - changes grouped by responsibility;
   - associated story, issue, task, or specification context;
   - validation or rollout claims already recorded by the change;
   - unresolved context that the available sources do not answer.

Keep sourced facts separate from inference. Describe what the branch is doing
without evaluating whether the implementation is correct or merge-ready.
