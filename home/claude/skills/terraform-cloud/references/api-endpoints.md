# Terraform Cloud API v2 — Full Endpoint Reference

Base URL: `https://app.terraform.io/api/v2`

## Organizations

| Method | Path | Description |
|--------|------|-------------|
| GET | `/organizations` | List organizations |
| GET | `/organizations/{name}` | Show organization |
| POST | `/organizations` | Create organization |
| PATCH | `/organizations/{name}` | Update organization |
| DELETE | `/organizations/{name}` | Delete organization |

## Workspaces

| Method | Path | Description |
|--------|------|-------------|
| GET | `/organizations/{org}/workspaces` | List workspaces (supports `search[name]`, `search[tags]`, `filter[project][id]`, `sort`, pagination) |
| GET | `/organizations/{org}/workspaces/{name}` | Show workspace by name |
| GET | `/workspaces/{id}` | Show workspace by ID |
| POST | `/organizations/{org}/workspaces` | Create workspace (required: `data.attributes.name`) |
| PATCH | `/workspaces/{id}` | Update workspace |
| DELETE | `/workspaces/{id}` | Force delete workspace |
| POST | `/workspaces/{id}/actions/safe-delete` | Safe delete (fails if managing resources, returns 409) |
| POST | `/workspaces/{id}/actions/lock` | Lock workspace (body: `{"reason": "..."}`) |
| POST | `/workspaces/{id}/actions/unlock` | Unlock workspace |
| POST | `/workspaces/{id}/actions/force-unlock` | Force unlock workspace |

## Runs

| Method | Path | Description |
|--------|------|-------------|
| GET | `/workspaces/{workspace_id}/runs` | List runs (supports `filter[status]`, `filter[operation]`, `filter[source]`, `search[user]`, `search[commit]`) |
| GET | `/organizations/{org}/runs` | List runs in org (supports `filter[workspace_names]`) |
| GET | `/runs/{id}` | Show run |
| POST | `/runs` | Create run (required: `data.relationships.workspace.data.id`) |
| POST | `/runs/{id}/actions/apply` | Apply run (body: `{"comment": "..."}`) |
| POST | `/runs/{id}/actions/discard` | Discard run |
| POST | `/runs/{id}/actions/cancel` | Cancel run |
| POST | `/runs/{id}/actions/force-cancel` | Force cancel run |
| POST | `/runs/{id}/actions/force-execute` | Force execute run |

### Run Create Attributes

- `message` — custom message
- `auto-apply` — boolean, auto-apply after plan
- `is-destroy` — boolean, destroy run
- `refresh-only` — boolean, refresh-only run
- `plan-only` — boolean, plan only (no apply)
- `variables` — array of `{key, value}` for run-specific variable overrides

## Plans

| Method | Path | Description |
|--------|------|-------------|
| GET | `/plans/{id}` | Show plan |
| GET | `/plans/{id}/json-output` | Get JSON execution plan (returns 307 redirect) |
| GET | `/runs/{id}/plan/json-output` | Get JSON plan via run ID |

Plan states: `pending`, `queued`, `running`, `errored`, `canceled`, `finished`, `unreachable`

## State Versions

| Method | Path | Description |
|--------|------|-------------|
| GET | `/workspaces/{workspace_id}/current-state-version` | Current state version |
| GET | `/state-versions?filter[workspace][name]={name}&filter[organization][name]={org}` | List state versions |
| GET | `/state-versions/{id}` | Show state version |
| POST | `/workspaces/{workspace_id}/state-versions` | Create state version |
| PATCH | `/workspaces/{workspace_id}/state-versions` | Rollback state version |

## State Version Outputs

| Method | Path | Description |
|--------|------|-------------|
| GET | `/workspaces/{workspace_id}/current-state-version-outputs` | Current outputs (no state read permission needed; sensitive values returned as null) |
| GET | `/state-versions/{id}/outputs` | List outputs for state version |
| GET | `/state-version-outputs/{id}` | Show specific output |

## Workspace Variables

| Method | Path | Description |
|--------|------|-------------|
| GET | `/workspaces/{workspace_id}/vars` | List variables |
| POST | `/workspaces/{workspace_id}/vars` | Create variable |
| PATCH | `/workspaces/{workspace_id}/vars/{var_id}` | Update variable |
| DELETE | `/workspaces/{workspace_id}/vars/{var_id}` | Delete variable |

### Variable Attributes

- `key` — variable name (required)
- `value` — variable value
- `category` — `"terraform"` or `"env"` (required)
- `hcl` — boolean, evaluate as HCL
- `sensitive` — boolean, hide value after creation
- `description` — optional description

## JSON API Format

All requests/responses follow JSON API spec. Request body structure:

```json
{
  "data": {
    "type": "resource-type",
    "attributes": { ... },
    "relationships": { ... }
  }
}
```

Response includes `data`, `links`, `meta` (for pagination).

## Pagination

Query params: `page[number]`, `page[size]` (max 100, default 20)

Response meta:
```json
{
  "meta": {
    "pagination": {
      "current-page": 1,
      "page-size": 20,
      "prev-page": null,
      "next-page": 2,
      "total-pages": 5,
      "total-count": 94
    }
  }
}
```

## Rate Limits

- Standard: 30 req/s per user
- Auth endpoints: 5-100 per minute/hour
