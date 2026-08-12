# Monday.com Project Management

Manage Spireworks project tasks on Monday.com using the Monday MCP tools. Create well-structured user stories, bugs, chores, spikes, and other task types on the sprint board.

## Board Architecture

- **Sprints Board** (ID: `3837453658`): `✨ Spireworks - Sprints` — day-to-day sprint tasks
- **Roadmap Board** (ID: `3837465611`): `🔮 Roadmap` — epics by division
- **Product Board** (ID: `3897394648`): `🧬 Product` — product components and infrastructure

Tasks link to epics via the `link_to_epics____` column (connects to Roadmap and Product boards).

## Creating Items

Always use `mcp__monday-mcp__create_item` with `boardId: 3837453658`.

Before creating, ask the user for anything not already clear from context:
1. **Item name** -- clear, descriptive title
2. **Type** -- Feature, Bug, Chore, Spike, Tech Debt, Hotfix, etc.
3. **Group** -- which sprint group (defaults to `new_group20264` = "Current Sprint")
4. **Priority** -- Critical, High, Medium, Low, Nice to have
5. **Roadmap epic** -- link to an existing epic if applicable

Always set on every item:
- **Role** (`status_18`): defaults to `Dev` unless specified otherwise
- **Owner** (`person`): set to the current user (look up their ID via `list_users_and_teams`)

### Column Reference

See [references/board-columns.md](references/board-columns.md) for full column IDs, types, and valid values.

## User Story Template

When creating a **Feature** (user story), structure the `long_text` (Task Description) field as:

```
**Context:**
[Brief background on why this feature is needed]

**User Story:**
As a [role], I want to [action] so that [benefit].

**Acceptance Criteria:**
- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]

**Notes:**
[Any additional context, links, or considerations]
```

Set column values:
```json
{
  "status_13": {"label": "Feature"},
  "status_1": {"label": "<priority>"},
  "status": {"label": "Ready to start"},
  "long_text": "<formatted description above>"
}
```

## Bug Report Template

When creating a **Bug**, structure the `long_text` (Task Description) field as:

```
**Summary:**
[One-line description of the bug]

**Steps to Reproduce:**
1. [Step 1]
2. [Step 2]
3. [Step 3]

**Expected Behavior:**
[What should happen]

**Current Behavior:**
[What actually happens]

**Environment:**
[Browser/device/installation if relevant]

**Notes:**
[Screenshots, logs, or additional context]
```

Set column values:
```json
{
  "status_13": {"label": "Bug"},
  "status_1": {"label": "<priority>"},
  "status": {"label": "Ready to start"},
  "long_text": "<formatted description above>"
}
```

## Chore Template

When creating a **Chore**, structure the `long_text` (Task Description) field as:

```
**What:**
[Clear description of the chore]

**Why:**
[Reason this maintenance/cleanup is needed]

**Scope:**
- [ ] [Task 1]
- [ ] [Task 2]
```

Set column values:
```json
{
  "status_13": {"label": "Chore"},
  "status_1": {"label": "<priority>"},
  "status": {"label": "Ready to start"},
  "long_text": "<formatted description above>"
}
```

## Spike Template

When creating a **Spike**, structure the `long_text` (Task Description) field as:

```
**Question:**
[What we need to learn/investigate]

**Context:**
[Why this spike is needed]

**Expected Output:**
- [ ] [Deliverable 1 - e.g., document findings]
- [ ] [Deliverable 2 - e.g., proof of concept]

**Time-box:**
[Suggested time limit for investigation]
```

Set column values:
```json
{
  "status_13": {"label": "Spike"},
  "status_1": {"label": "<priority>"},
  "status": {"label": "Ready to start"},
  "long_text": "<formatted description above>"
}
```

## Querying Items

Use `mcp__monday-mcp__get_board_items_page` with `boardId: 3837453658`.

Common queries:
- **My tasks**: filter by `person` column with `assigned_to_me`
- **Current sprint**: filter by group `new_group20264`
- **By type**: filter `status_13` (Type) — Bug=2, Feature=1, Chore=6, Spike=4
- **By status**: filter `status` — Started=0, Code Review=3, Staging QA=4, Pending deploy=2, Completed/Deployed=1
- **By priority**: filter `status_1` — Critical=0, High=2, Medium=7, Low=12

See [references/board-columns.md](references/board-columns.md) for all filter values and guidelines.

## Linking to Epics

To link a task to a roadmap epic, use `mcp__monday-mcp__change_item_column_values` after creating the item:
```json
{
  "boardId": 3837453658,
  "itemId": <new_item_id>,
  "columnValues": "{\"link_to_epics____\":{\"item_ids\":[<epic_id>]}}"
}
```

Search for epics on the Roadmap board (ID: `3837465611`) using `get_board_items_page` with a `searchTerm`.

## Updating Item Status

Use `mcp__monday-mcp__change_item_column_values`:
```json
{
  "boardId": 3837453658,
  "itemId": <item_id>,
  "columnValues": "{\"status\":{\"label\":\"Started\"}}"
}
```

## Adding Comments

Use `mcp__monday-mcp__create_update` to add discussion/notes to an item:
```json
{
  "itemId": <item_id>,
  "body": "Comment text here"
}
```

## PR and Monday Integration Workflow

When creating Monday items alongside PRs, follow this end-to-end flow:

### 1. Create the Monday item first

Create the item with all required fields (type, priority, role, owner, description). The description should follow the appropriate template (Bug, Feature, Chore, etc.).

### 2. Update PR title with ticket prefix

PR titles must include the Monday pulse ID as a prefix:

```
[PULSE_ID] type: description
```

Examples:
- `[11723668193] fix: handle nil image settings in preset button image callback`
- `[11723648134] feat: add Airbrake JS error reporting to admin entry points`

### 3. Update PR body with story link

The first line of the PR body must link to the Monday story, matching the PR template:

```
[Story Link PULSE_ID](https://durstorg.monday.com/boards/3837453658/pulses/PULSE_ID)
```

The rest of the PR body follows `.github/PULL_REQUEST_TEMPLATE.md` (Summary, Context, How to Test, etc.).

### 4. Add an update to the Monday item

After opening the PR, add a comment to the Monday item with:
- The PR link
- A summary of what changed (files, approach)
- Any relevant context

### 5. Set status to match PR state

| PR state | Monday status |
|---|---|
| Draft / WIP | Started |
| Ready for review | Code Review |
| Approved, pending merge | Pending deploy |
| Merged to main | Pending deploy |
| Deployed | Completed/Deployed |

### Batch workflow

When creating multiple related items (e.g., a bug fix and a chore discovered together):
1. Create all Monday items
2. Open all PRs
3. Cross-reference the items in PR descriptions where relevant
4. Add updates to each Monday item with its PR link

## Sprint Groups

| Group ID | Name |
|---|---|
| `new_group20264` | Current Sprint |
| `new_group27525` | Next issues |
| `new_group__1` | Last sprint / Ready for Demo |
| `infrastructure` | Infrastructure & security |
| `new_group19045` | Backlog |
| `group_title` | Icebox / On Hold |
| `new_group2094` | Done/Completed |
