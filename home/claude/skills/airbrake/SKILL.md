# Airbrake Issue Reviewer

Review Airbrake error groups, inspect individual notices, and manage projects via the Airbrake API.

## Configuration

- **Base URL**: `https://api.airbrake.io`
- **User Key**: `1cbe8d9c9c21174ab768c6bb745e01c85c205a59`
- **Auth**: Append `?key=USER_KEY` (or `&key=USER_KEY`) to all requests

## Quick Commands

Use `curl` via Bash to interact with the Airbrake API. Always use `-s` for silent mode and pipe through `jq` for readable output.

### List Projects

```bash
curl -s "https://api.airbrake.io/api/v4/projects?key=1cbe8d9c9c21174ab768c6bb745e01c85c205a59" | jq .
```

### List Error Groups (All Projects)

```bash
curl -s "https://api.airbrake.io/api/v4/groups?key=1cbe8d9c9c21174ab768c6bb745e01c85c205a59" | jq .
```

### List Error Groups (Specific Project)

```bash
curl -s "https://api.airbrake.io/api/v4/projects/{PROJECT_ID}/groups?key=1cbe8d9c9c21174ab768c6bb745e01c85c205a59" | jq .
```

### Get Group Details

```bash
curl -s "https://api.airbrake.io/api/v4/projects/{PROJECT_ID}/groups/{GROUP_ID}?key=1cbe8d9c9c21174ab768c6bb745e01c85c205a59" | jq .
```

### List Notices (Individual Occurrences)

```bash
curl -s "https://api.airbrake.io/api/v4/projects/{PROJECT_ID}/groups/{GROUP_ID}/notices?key=1cbe8d9c9c21174ab768c6bb745e01c85c205a59" | jq .
```

## Workflow

### Reviewing Issues

1. **List projects** to identify the target project and its ID
2. **List error groups** for the project, filtering by parameters as needed
3. **Get group details** to see the error type, message, backtrace, and context
4. **List notices** to see individual occurrences with their specific context (user, URL, environment variables)
5. **Analyze patterns** across notices to determine root cause

### Triaging Issues

When reviewing errors, prioritize by:
- **Notice count** (`noticeTotalCount`) — high-frequency errors impact more users
- **Recency** (`lastNoticeAt`) — recent errors may indicate new regressions
- **Environment** — production errors take priority over staging

## Group Query Parameters

| Parameter | Description |
|-----------|-------------|
| `page` | Page number (default: 1) |
| `limit` | Results per page (default: 20) |
| `order` | Sort order |
| `deploy_id` | Filter by deploy |
| `archived` | Filter archived groups |
| `muted` | Filter muted groups |
| `start_time` | Filter by start time |
| `end_time` | Filter by end time |

## Group Response Fields

Key fields in a group object:
- `id` — Group identifier
- `projectId` — Associated project
- `errors[].type` — Error class/type
- `errors[].message` — Error message
- `errors[].backtrace[]` — Stack trace (`file`, `function`, `line`, `column`)
- `context.environment` — Environment name
- `context.os`, `context.language` — Runtime info
- `context.userId`, `context.userName`, `context.userEmail` — Affected user
- `context.url` — URL where error occurred
- `resolved` — Whether the group is resolved
- `noticeCount` / `noticeTotalCount` — Occurrence counts
- `lastNoticeAt` — Most recent occurrence
- `createdAt` — First occurrence

## Additional Operations

| Operation | Method | Endpoint |
|-----------|--------|----------|
| Mute group | PUT | `/api/v4/projects/{PROJECT_ID}/groups/{GROUP_ID}/muted?key=USER_KEY` |
| Unmute group | PUT | `/api/v4/projects/{PROJECT_ID}/groups/{GROUP_ID}/unmuted?key=USER_KEY` |
| Delete group | DELETE | `/api/v4/projects/{PROJECT_ID}/groups/{GROUP_ID}?key=USER_KEY` |
| List deploys | GET | `/api/v4/projects/{PROJECT_ID}/deploys?key=USER_KEY` |
| Get deploy | GET | `/api/v4/projects/{PROJECT_ID}/deploys/{DEPLOY_ID}?key=USER_KEY` |
| Project stats | GET | `/api/v4/projects/{PROJECT_ID}/stats?key=USER_KEY` |
| Project activities | GET | `/api/v4/projects/{PROJECT_ID}/activities?key=USER_KEY` |
| Group stats | GET | `/api/v5/projects/{PROJECT_ID}/groups/{GROUP_ID}/stats?period=PERIOD&time__gte=TIME&key=USER_KEY` |

See [references/api-details.md](references/api-details.md) for full API reference.
