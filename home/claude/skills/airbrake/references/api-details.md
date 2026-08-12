# Airbrake API Reference

## Authentication

Two key types:
- **Project API key** (`PROJECT_KEY`) — used to submit errors and track deploys
- **User API key** (`USER_KEY`) — used to access project data via API

All requests authenticate via query string: `?key=KEY_VALUE`

### User Token (Session-Based)

Create a time-limited token:

```bash
curl -s -X POST "https://api.airbrake.io/api/v4/sessions" \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"pass"}' | jq .
```

Response includes a `token` field usable as `USER_TOKEN`.

## Pagination

### Offset-Based (Default)

Parameters: `page` (default: 1), `limit` (default: 20)

Response shape:
```json
{
  "groups": [...],
  "count": 150,
  "page": 1
}
```

### Cursor-Based

Parameters: `start`, `end`, `limit`

Response includes `start` and `end` cursor values for next/previous pages.

## Projects API

### List All Projects

```
GET /api/v4/projects?key=USER_KEY
```

### Get Project Details

```
GET /api/v4/projects/{PROJECT_ID}?key=USER_KEY
```

## Groups API

Groups represent categorized errors (each unique error type/message combination).

### List Groups (All Projects)

```
GET /api/v4/groups?key=USER_KEY
```

### List Groups (Single Project)

```
GET /api/v4/projects/{PROJECT_ID}/groups?key=USER_KEY
```

**Query Parameters:**

| Param | Type | Description |
|-------|------|-------------|
| `page` | int | Page number (default: 1) |
| `limit` | int | Results per page (default: 20) |
| `order` | string | Sort order |
| `deploy_id` | int | Filter by deploy ID |
| `archived` | bool | Filter archived groups |
| `muted` | bool | Filter muted groups |
| `start_time` | string | Filter start time |
| `end_time` | string | Filter end time |

### Get Group Details

```
GET /api/v4/projects/{PROJECT_ID}/groups/{GROUP_ID}?key=USER_KEY
```

### Group Response Object

```json
{
  "id": 123456,
  "projectId": 789,
  "resolved": false,
  "errors": [
    {
      "type": "NoMethodError",
      "message": "undefined method 'foo' for nil:NilClass",
      "backtrace": [
        {
          "file": "app/models/user.rb",
          "function": "process",
          "line": 42,
          "column": 5
        }
      ]
    }
  ],
  "context": {
    "environment": "production",
    "os": "Linux",
    "language": "Ruby 3.2.0",
    "url": "https://app.example.com/users/123",
    "rootDirectory": "/app",
    "userId": "user_456",
    "userName": "Jane Doe",
    "userEmail": "jane@example.com"
  },
  "lastDeployId": 100,
  "lastDeployAt": "2025-01-15T10:00:00Z",
  "lastNoticeId": "abc-123",
  "lastNoticeAt": "2025-01-20T14:30:00Z",
  "noticeCount": 42,
  "noticeTotalCount": 150,
  "createdAt": "2024-12-01T08:00:00Z"
}
```

### Mute/Unmute Group

```
PUT /api/v4/projects/{PROJECT_ID}/groups/{GROUP_ID}/muted?key=USER_KEY
PUT /api/v4/projects/{PROJECT_ID}/groups/{GROUP_ID}/unmuted?key=USER_KEY
```

### Delete Group

```
DELETE /api/v4/projects/{PROJECT_ID}/groups/{GROUP_ID}?key=USER_KEY
```

## Notices API

Notices are individual error occurrences within a group.

### List Notices

```
GET /api/v4/projects/{PROJECT_ID}/groups/{GROUP_ID}/notices?key=USER_KEY
```

**Query Parameters:**

| Param | Type | Description |
|-------|------|-------------|
| `page` | int | Page number |
| `limit` | int | Results per page |
| `version` | string | Filter by version |

### Check Notice Status

```
GET /api/v4/projects/{PROJECT_ID}/notice-status/{NOTICE_UUID}?key=USER_KEY
```

Response codes: `processed`, `rejected`, `archived`, `not_found`

## Deploys API

### List Deploys

```
GET /api/v4/projects/{PROJECT_ID}/deploys?key=USER_KEY
```

### Get Deploy Details

```
GET /api/v4/projects/{PROJECT_ID}/deploys/{DEPLOY_ID}?key=USER_KEY
```

### Create Deploy

```
POST /api/v4/projects/{PROJECT_ID}/deploys?key=PROJECT_KEY
```

Body: `environment`, `username`, `email`, `repository`, `revision`, `version`

## Statistics API

### Group Statistics

```
GET /api/v5/projects/{PROJECT_ID}/groups/{GROUP_ID}/stats?period=PERIOD&time__gte=TIME&key=USER_KEY
```

**Required Parameters:**
- `period` — Aggregation period
- `time__gte` — Start time

**Optional:**
- `time__lt` — End time
- `limit` — Max results

### Project Statistics

```
GET /api/v4/projects/{PROJECT_ID}/stats?key=USER_KEY
```

Parameters: `period`, `time__gte`, `limit`

## Project Activities

```
GET /api/v4/projects/{PROJECT_ID}/activities?key=USER_KEY
```

## Useful Patterns

### Paginate Through All Groups

```bash
page=1
while true; do
  result=$(curl -s "https://api.airbrake.io/api/v4/projects/{PROJECT_ID}/groups?key=USER_KEY&page=$page&limit=100")
  count=$(echo "$result" | jq '.groups | length')
  if [ "$count" -eq 0 ]; then break; fi
  echo "$result" | jq '.groups[] | {id, type: .errors[0].type, message: .errors[0].message, count: .noticeTotalCount}'
  page=$((page + 1))
done
```

### Get Top Errors by Occurrence Count

```bash
curl -s "https://api.airbrake.io/api/v4/projects/{PROJECT_ID}/groups?key=USER_KEY&limit=100" | \
  jq '[.groups[] | {id, type: .errors[0].type, message: .errors[0].message, count: .noticeTotalCount}] | sort_by(-.count) | .[:10]'
```

### Get Recent Unresolved Errors

```bash
curl -s "https://api.airbrake.io/api/v4/projects/{PROJECT_ID}/groups?key=USER_KEY&limit=50" | \
  jq '[.groups[] | select(.resolved == false)] | sort_by(.lastNoticeAt) | reverse | .[:10] | .[] | {id, type: .errors[0].type, message: .errors[0].message, last: .lastNoticeAt, count: .noticeTotalCount}'
```
