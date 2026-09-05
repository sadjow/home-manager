---
name: airbrake
description: Review Airbrake projects and error groups through the Airbrake API. Use when triaging production errors, analyzing issue patterns, or inspecting projects, groups, deploys, and notices.
---

# Airbrake Issue Reviewer

Review Airbrake error groups without exposing credentials or broadly dumping potentially sensitive notice data.

## Configuration

- **Base URL**: `https://api.airbrake.io`
- **Authentication**: Read the user API key from `AIRBRAKE_USER_KEY`.
- Never store an API key in this skill, a command transcript, a repository, or a URL written to output.
- Verify that the variable exists without printing it:

```bash
test -n "${AIRBRAKE_USER_KEY:-}"
```

Do not use `env`, `printenv`, `set`, `echo`, shell tracing, or another command that could expose the value.

## Read-only workflow

1. List projects to identify the exact project and ID.
2. List group summaries for that project.
3. Inspect a single group using a redacted projection.
4. Inspect the smallest necessary set of notice fields only when group-level evidence is insufficient.
5. Analyze frequency, recency, environment, deployment correlation, and affected operations.

Do not fetch or print full API responses. Notices can contain request data, user data, headers, URLs, environment values, and exception messages with secrets or personal information.

## Safe command patterns

### List projects

```bash
curl -sG "https://api.airbrake.io/api/v4/projects" \
  --data-urlencode "key=${AIRBRAKE_USER_KEY}" | \
  jq '[.projects[] | {id, name}]'
```

### List error-group summaries

```bash
curl -sG "https://api.airbrake.io/api/v4/projects/{PROJECT_ID}/groups" \
  --data-urlencode "key=${AIRBRAKE_USER_KEY}" \
  --data-urlencode "limit=20" | \
  jq '[.groups[] | {
    id,
    projectId,
    errorTypes: [.errors[]?.type],
    noticeTotalCount,
    lastNoticeAt,
    createdAt,
    resolved,
    muted
  }]'
```

### Inspect one group

```bash
curl -sG "https://api.airbrake.io/api/v4/projects/{PROJECT_ID}/groups/{GROUP_ID}" \
  --data-urlencode "key=${AIRBRAKE_USER_KEY}" | \
  jq '{
    id,
    projectId,
    errorTypes: [.errors[]?.type],
    noticeTotalCount,
    lastNoticeAt,
    createdAt,
    resolved,
    muted
  }'
```

### Inspect notice metadata

Use this only after selecting a specific group. Keep the limit small and omit request, user, environment-variable, header, parameter, session, body, and message fields.

```bash
curl -sG "https://api.airbrake.io/api/v4/projects/{PROJECT_ID}/groups/{GROUP_ID}/notices" \
  --data-urlencode "key=${AIRBRAKE_USER_KEY}" \
  --data-urlencode "limit=5" | \
  jq '[.notices[] | {
    id,
    createdAt,
    errorTypes: [.errors[]?.type],
    environment: .context.environment,
    backtrace: [.errors[]?.backtrace[]? | {file, function, line}] | .[:12]
  }]'
```

If a message or request attribute is genuinely necessary, retrieve only that field and redact credentials, tokens, personal data, query strings, and payload values before presenting it.

## Triage priorities

- **Frequency**: prioritize high-volume groups.
- **Recency**: distinguish active incidents from historical noise.
- **Environment**: prioritize production unless the task specifies otherwise.
- **Deployment correlation**: compare first and last occurrence with deploys.
- **Operational impact**: prioritize request failures, job failures, and data-integrity risks over benign background noise.

## Mutating operations

Muting, resolving, deleting, or otherwise changing an Airbrake group requires explicit user authorization. Resolve the exact project and group with read-only checks before any mutation.

See [references/api-details.md](references/api-details.md) for endpoint shapes. Treat examples containing `USER_KEY` as placeholders for the environment variable, never as literal credentials.
