# Board Column Reference

## Sprints Board (ID: 3837453658)

### Columns

| Column ID | Title | Type | Notes |
|---|---|---|---|
| `name` | Name | name | Task title |
| `subitems` | Sub Tasks | subtasks | Linked to subitem board 3837453808 |
| `link_to_epics____` | Roadmap | board_relation | Links to Roadmap (3837465611) and Product (3897394648) |
| `people9` | Requester | people | Who requested the task |
| `person` | Owner | people | Who is working on it |
| `people` | QA | people | QA assignee |
| `status` | Status | status | Workflow status |
| `status_13` | Type | status | Task type classification |
| `status_18` | Role | status | Team role |
| `status_1` | Priority | status | Task priority |
| `numbers` | Estimated SP | numbers | Story points estimate (suffix: " SP") |
| `numbers2` | Actual SP | numbers | Actual story points (suffix: " SP") |
| `tags` | Tags | tags | Categorization tags |
| `check` | Unplanned | checkbox | Whether task was unplanned |
| `dependent_on` | Dependent On | dependency | Task dependencies |
| `timeline` | Sprint Timeframe | timeline | Sprint date range |
| `date` | Started At | date | When work started |
| `date1` | Deployed At | date | When deployed |
| `date0` | Desired due date | date | Target completion date |
| `long_text` | Task Description | long_text | Full description |
| `color` | Installations | status | Which installation |
| `text` | Pivotal Tracker ID | text | Legacy reference |

### Status Labels (column: `status`)

| ID | Label |
|---|---|
| 0 | Started |
| 1 | Completed/Deployed |
| 2 | Pending deploy |
| 3 | Code Review |
| 4 | Staging QA |
| 5 | To refine |
| 6 | QA on hold |
| 7 | Restarted |
| 8 | Blocked |
| 9 | Ready to start |
| 10 | Prod QA |
| 11 | To estimate |
| 12 | QA in progress |
| 13 | Blocked on design |
| 14 | Closed w reason |
| 15 | To Review |
| 16 | Unreproducible |
| 103 | On Hold |

### Type Labels (column: `status_13`)

| ID | Label |
|---|---|
| 0 | Release |
| 1 | Feature |
| 2 | Bug |
| 3 | Tech Debt |
| 4 | Spike |
| 6 | Chore |
| 7 | Security |
| 8 | Design |
| 9 | Documentation |
| 10 | EPIC |
| 11 | Vendor requirement |
| 12 | QA |
| 13 | Infrastructure |
| 155 | Hotfix |

### Role Labels (column: `status_18`)

| ID | Label |
|---|---|
| 0 | Dev |
| 1 | QA |
| 2 | DevOps |
| 3 | Design |
| 4 | Product |
| 6 | FieldOps |
| 7 | Ops |

### Priority Labels (column: `status_1`)

| ID | Label |
|---|---|
| 0 | Critical |
| 1 | Nice to have |
| 2 | High |
| 7 | Medium |
| 12 | Low |

### Installation Labels (column: `color`)

| ID | Label |
|---|---|
| 0 | 151 |
| 1 | obp |
| 2 | sven |
| 3 | onewtc-spire |
| 4 | onewtc-podium |
| 6 | obp-lab |
| 7 | nixos |

## Roadmap Board (ID: 3837465611)

### Key Columns

| Column ID | Title | Type |
|---|---|---|
| `name` | Name | name |
| `board_relation` | Product | board_relation |
| `status` | Priority | status (stars) |
| `color_mkxx1hz` | Status | status |
| `people5` | Epic Owner | people |
| `connect_boards_1` | Sprints | board_relation |
| `timeline` | Timeline | timeline |
| `long_text` | Description | long_text |

### Roadmap Status (column: `color_mkxx1hz`)

| ID | Label |
|---|---|
| 0 | Started |
| 1 | Planned |
| 2 | Completed |
| 3 | On Hold |

### Roadmap Groups

| Group ID | Name |
|---|---|
| `duplicate_of_future` | Current |
| `duplicate_of_2023_q180909` | Future |
| `completed__1` | Completed |
| `q4_2022` | R&D |
| `new_group13009` | Backlog |

## Product Board (ID: 3897394648)

### Key Columns

| Column ID | Title | Type |
|---|---|---|
| `name` | Name | name |
| `people5` | Epic Owner | people |
| `board_relation` | Roadmap | board_relation |
| `long_text` | Description | long_text |
| `status` | Priority | status |
| `timeline` | Timeline | timeline |

### Product Priority (column: `status`)

| ID | Label |
|---|---|
| 0 | Must Have |
| 1 | Unclear |
| 2 | Nice to Have |
| 3 | Critical |
| 4 | Best Effort |

## Filtering Guidelines

### Operator Rules
- `any_of`, `not_any_of`, `between`: compareValue MUST be an **array**
- `is_empty`, `is_not_empty`: compareValue MUST be an **empty array** `[]`
- `greater_than`, `lower_than`: compareValue MUST be a **single string or number**
- `contains_terms`, `contains_text`, `not_contains_text`: compareValue MUST be a **single string**

### People Filtering
- Current user: `"assigned_to_me"`
- Specific person: `"person-<id>"`
- Specific team: `"team-<id>"`

### Status Filtering
- Use label **ID** (number) with `any_of`/`not_any_of`
- Use label **text** with `contains_terms`

### Date Filtering
- Exact date: `["2026-01-01", "EXACT"]` with `any_of`
- Relative: `"TODAY"`, `"TOMORROW"`, `"THIS_WEEK"`, `"ONE_WEEK_AGO"`
