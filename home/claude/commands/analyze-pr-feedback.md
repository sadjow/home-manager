---
description: Fetch and analyze GitHub PR review comments for the current branch using gh CLI
allowed-tools: Bash(gh pr view:*), Bash(gh pr checks:*), Bash(gh api:*), Bash(git branch:*), Bash(git rev-parse:*)
argument-hint: [pr-number]
---

Analyze code review feedback from the GitHub pull request for the current branch.

## Your Task

1. **Identify PR**: Get the PR number for the current branch (or use provided: $ARGUMENTS)
2. **Fetch Comments**: Retrieve all review comments, inline code comments, and general feedback
3. **Analyze & Categorize**: Organize feedback by type and priority
4. **Select a Capability Route**: Keep work in the current agent unless the user explicitly authorizes delegation
5. **Provide Action Plan**: Create actionable next steps

## Step 1: Get PR Information

```bash
# Get current branch
current_branch=$(git rev-parse --abbrev-ref HEAD)

# Get PR number for current branch (or use $ARGUMENTS if provided)
if [ -n "$ARGUMENTS" ]; then
  pr_number="$ARGUMENTS"
else
  pr_number=$(gh pr view --json number -q .number 2>/dev/null)
fi

# If no PR found
if [ -z "$pr_number" ]; then
  echo "No PR found for current branch. Create one first with: gh pr create"
  exit 1
fi
```

## Step 2: Fetch All Feedback

```bash
# Get PR details with reviews
gh pr view $pr_number --json title,body,reviews,comments,reviewRequests,reviewDecision

# Get detailed review comments (inline code comments)
gh api repos/{owner}/{repo}/pulls/$pr_number/comments

# Get PR checks status
gh pr checks $pr_number
```

## Step 3: Analyze & Categorize Feedback

Organize comments into categories:

### 🔴 **Critical Issues** (Must fix before merge)
- Blocking reviews
- Security vulnerabilities
- Breaking changes
- Failed CI checks
- Requested changes that block approval

### 🟡 **Suggestions** (Should address)
- Code quality improvements
- Performance optimizations
- Refactoring recommendations
- Better naming or structure
- Missing tests or documentation

### 🟢 **Questions/Discussion** (Respond or clarify)
- Clarification requests
- Design discussions
- Alternative approach suggestions
- "Why did you..." questions

### 📝 **Nitpicks** (Optional, low priority)
- Style preferences
- Minor formatting
- Typo corrections

### ✅ **Approvals/Praise** (Acknowledged)
- Positive feedback
- LGTM comments
- Approved reviews

## Step 4: Select a Capability Route

Analyze and plan straightforward follow-up in the current agent. Do not invoke a specialist merely because this command names one.

If the user explicitly asks for delegation, select the smallest specialist set from the actual feedback:

**For DRY/SSOT violations or duplication**:
→ Use `clean-code-specialist` agent

**For language-specific improvements** (Elixir code):
→ Use `elixir-specialist` agent

**For general refactoring**:
→ Use `clean-code-specialist` agent

**For testing feedback**:
→ Use `/test-this` command

Example:
```
Reviewer feedback: "This function has duplicate timeout values"
→ The current agent can handle this. If you explicitly want delegation, the clean-code-specialist is the relevant specialist.
```

## Step 5: Generate Action Plan

For each comment thread, provide:

1. **Comment Summary**: What the reviewer said
2. **Location**: File and line number (if inline comment)
3. **Category**: Critical/Suggestion/Question/Nitpick
4. **Analysis**: Your interpretation and context
5. **Proposed Action**: What to do about it
6. **Capability Route**: Current agent, deterministic command, or an explicitly authorized specialist
7. **Response Draft**: Suggested reply to reviewer (if needed)

## Output Format

```markdown
# PR Review Analysis: PR #${pr_number}

**Title**: ${pr_title}
**Status**: ${review_decision}
**Checks**: ${checks_status}

---

## Summary

- Total comments: X
- Critical issues: X
- Suggestions: X
- Questions: X
- Approvals: X

---

## Critical Issues 🔴

### 1. [File: src/payment.js:42]

**Reviewer**: @alice
**Comment**: "This hardcoded API key should be in environment variables"

**Analysis**: Security vulnerability - API keys should never be committed

**Proposed Action**:
1. Move to environment variable
2. Update .env.example
3. Add to .gitignore if not already there

**Capability Route**: Current agent; no specialist needed

**Response Draft**:
"Good catch! Moving to environment variable in next commit."

---

### 2. [File: src/services/user.js:15-30]

**Reviewer**: @bob
**Comment**: "This function has too much logic and duplicates the timeout value from auth.js"

**Analysis**: Code smell - long function + DRY violation

**Proposed Action**:
1. Extract timeout constant to config/constants.js
2. Break function into smaller, focused functions

**Capability Route**: Current agent by default; clean-code-specialist only after explicit delegation authorization

**Response Draft**:
"Agreed on both points. Refactoring to extract constants and split the function."

---

## Suggestions 🟡

[Continue with suggestions...]

---

## Questions/Discussion 🟢

[Continue with questions...]

---

## Recommended Next Steps

1. **Immediate Actions** (Critical):
   - [ ] Fix security issue in payment.js:42
   - [ ] Address blocking review comments

2. **Optional Delegation** (only when explicitly requested):
   - [ ] Clean code specialist for the bounded user.js refactoring
   - [ ] Run `/extract-constants` on payment module

3. **Reply to Reviewers**:
   - [ ] Respond to @alice's question about error handling
   - [ ] Acknowledge @bob's suggestion

4. **Before Re-requesting Review**:
   - [ ] Run all tests: `npm test` or `mix test`
   - [ ] Verify CI checks pass
   - [ ] Commit with: `/conventional-commit`

---

## Delegation Boundary

Continue in the current agent unless the user explicitly requests delegation. Drafting a response is not permission to send it, and preparing a commit plan is not permission to stage, commit, or push.
```

## Special Cases

### No Reviews Yet
```
No reviews found for this PR yet.

Would you like me to:
- Review the PR myself for potential issues?
- Check for common problems before reviewers look?
- Run `/review-dry` and `/review-comments` to self-review?
```

### Conflicting Feedback
```
⚠️ Conflicting feedback detected:

Reviewer A: "Extract this into separate functions"
Reviewer B: "This is fine as-is, don't over-engineer"

Analysis: [Provide your analysis and suggest discussing with team]
```

### Failed CI Checks
```
❌ CI Checks Failed:
- Tests: 2 failing
- Linting: 5 errors

Priority: Fix these before addressing review comments
Action: Review failures and fix root causes
```

## Tips for Responding to Reviews

1. **Acknowledge all feedback**: Even if you disagree, thank reviewers
2. **Explain decisions**: If not implementing a suggestion, explain why
3. **Ask for clarification**: If feedback is unclear
4. **Update the PR**: When explicitly authorized, leave the exact approved summary comment
5. **Re-request review**: When explicitly authorized, request the named reviewer through the supported GitHub workflow

## After Addressing Feedback

Stop after analysis unless the user separately asks for implementation. Do not stage, commit, push, reply, post a summary, or re-request review without authorization for that distinct action. Before an authorized commit, test the completed change; before any authorized GitHub write, show the exact target and wording.
