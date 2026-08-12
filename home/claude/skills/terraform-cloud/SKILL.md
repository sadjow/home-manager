---
name: terraform-cloud
description: Interact with the HCP Terraform (Terraform Cloud) API to manage workspaces, runs, plans, variables, state, and organizations. Use when the user asks to check terraform runs, list workspaces, trigger plans, view state outputs, manage variables, or any Terraform Cloud operation.
---

# Terraform Cloud API

Interact with HCP Terraform (Terraform Cloud) via its REST API v2.

## Authentication

Read the token from `~/.terraform.d/credentials.tfrc.json` and strip whitespace:

```bash
TFC_TOKEN=$(cat ~/.terraform.d/credentials.tfrc.json | jq -r '.credentials["app.terraform.io"].token' | tr -d '\n\r')
```

All requests use:

```bash
-H "Authorization: Bearer $TFC_TOKEN"
```

Base URL: `https://app.terraform.io/api/v2`

**IMPORTANT:** URL-encode square brackets in query parameters. Use `%5B` for `[` and `%5D` for `]`. Example: `search%5Bname%5D=foo` instead of `search[name]=foo`. Alternatively, use single quotes around URLs with brackets.

## Common Operations

### List Organizations

```bash
curl -s --header "Authorization: Bearer $TFC_TOKEN" \
  https://app.terraform.io/api/v2/organizations | jq '.data[] | {id: .id, name: .attributes.name}'
```

### List Workspaces

```bash
curl -s --header "Authorization: Bearer $TFC_TOKEN" \
  "https://app.terraform.io/api/v2/organizations/{org}/workspaces" | jq '.data[] | {id: .id, name: .attributes.name}'
```

Search by name:
```bash
curl -s --header "Authorization: Bearer $TFC_TOKEN" \
  "https://app.terraform.io/api/v2/organizations/{org}/workspaces?search[name]={query}" | jq '.data[] | {id: .id, name: .attributes.name}'
```

### Show Workspace

```bash
curl -s --header "Authorization: Bearer $TFC_TOKEN" \
  "https://app.terraform.io/api/v2/organizations/{org}/workspaces/{name}" | jq '.data'
```

### List Runs for Workspace

```bash
curl -s --header "Authorization: Bearer $TFC_TOKEN" \
  "https://app.terraform.io/api/v2/workspaces/{workspace_id}/runs" | jq '.data[] | {id: .id, status: .attributes.status, message: .attributes.message}'
```

Filter by status:
```bash
curl -s --header "Authorization: Bearer $TFC_TOKEN" \
  "https://app.terraform.io/api/v2/workspaces/{workspace_id}/runs?filter[status]=planned,applied" | jq '.data[]'
```

### Show Run Details

```bash
curl -s --header "Authorization: Bearer $TFC_TOKEN" \
  "https://app.terraform.io/api/v2/runs/{run_id}" | jq '.data'
```

### Create a Run (Trigger Plan)

```bash
curl -s --header "Authorization: Bearer $TFC_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data '{"data":{"attributes":{"message":"Triggered via API"},"type":"runs","relationships":{"workspace":{"data":{"type":"workspaces","id":"{workspace_id}"}}}}}' \
  https://app.terraform.io/api/v2/runs | jq '.data | {id: .id, status: .attributes.status}'
```

### Apply a Run

```bash
curl -s --header "Authorization: Bearer $TFC_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data '{"comment":"Approved via API"}' \
  "https://app.terraform.io/api/v2/runs/{run_id}/actions/apply"
```

### Discard a Run

```bash
curl -s --header "Authorization: Bearer $TFC_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data '{"comment":"Discarded via API"}' \
  "https://app.terraform.io/api/v2/runs/{run_id}/actions/discard"
```

### Cancel a Run

```bash
curl -s --header "Authorization: Bearer $TFC_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  "https://app.terraform.io/api/v2/runs/{run_id}/actions/cancel"
```

### View Plan (from a Run)

```bash
PLAN_ID=$(curl -s --header "Authorization: Bearer $TFC_TOKEN" \
  "https://app.terraform.io/api/v2/runs/{run_id}" | jq -r '.data.relationships.plan.data.id')
curl -s --header "Authorization: Bearer $TFC_TOKEN" \
  "https://app.terraform.io/api/v2/plans/$PLAN_ID" | jq '.data.attributes'
```

### Current State Version Outputs

```bash
curl -s --header "Authorization: Bearer $TFC_TOKEN" \
  "https://app.terraform.io/api/v2/workspaces/{workspace_id}/current-state-version-outputs" | jq '.data[] | {name: .attributes.name, value: .attributes.value}'
```

### List Variables

```bash
curl -s --header "Authorization: Bearer $TFC_TOKEN" \
  "https://app.terraform.io/api/v2/workspaces/{workspace_id}/vars" | jq '.data[] | {id: .id, key: .attributes.key, value: .attributes.value, category: .attributes.category, sensitive: .attributes.sensitive}'
```

### Create Variable

```bash
curl -s --header "Authorization: Bearer $TFC_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data '{"data":{"type":"vars","attributes":{"key":"{key}","value":"{value}","category":"terraform","sensitive":false}}}' \
  "https://app.terraform.io/api/v2/workspaces/{workspace_id}/vars" | jq '.data'
```

### Update Variable

```bash
curl -s --header "Authorization: Bearer $TFC_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request PATCH \
  --data '{"data":{"id":"{var_id}","type":"vars","attributes":{"value":"{new_value}"}}}' \
  "https://app.terraform.io/api/v2/workspaces/{workspace_id}/vars/{var_id}" | jq '.data'
```

### Delete Variable

```bash
curl -s --header "Authorization: Bearer $TFC_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request DELETE \
  "https://app.terraform.io/api/v2/workspaces/{workspace_id}/vars/{var_id}"
```

### Lock/Unlock Workspace

```bash
curl -s --header "Authorization: Bearer $TFC_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data '{"reason":"Locked via API"}' \
  "https://app.terraform.io/api/v2/workspaces/{workspace_id}/actions/lock"

curl -s --header "Authorization: Bearer $TFC_TOKEN" \
  --request POST \
  "https://app.terraform.io/api/v2/workspaces/{workspace_id}/actions/unlock"
```

## Pagination

List endpoints support `page[number]` and `page[size]` (max 100). Response includes `meta.pagination` with `current-page`, `total-pages`, `total-count`.

```bash
"https://app.terraform.io/api/v2/organizations/{org}/workspaces?page[size]=100&page[number]=1"
```

## Rate Limits

30 requests per second per user. Sensitive endpoints (auth, SMS) have lower limits.

## Run Statuses

`pending` → `plan_queued` → `planning` → `planned` → `confirmed` → `apply_queued` → `applying` → `applied`

Error/cancel states: `errored`, `canceled`, `discarded`, `force_canceled`

## Resources

### references/
- `api-endpoints.md` — Full endpoint reference with all methods, paths, and parameters
