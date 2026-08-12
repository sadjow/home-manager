---
name: ecs-rails-runner
description: Execute Rails commands on ECS production/staging via aws-vault and devenv. Use when the user asks to run Rails console, Rails runner, rake tasks, or any command against staging or production ECS containers. Also use for investigating production data, checking user/record state, running one-off scripts, or troubleshooting production issues.
---

# ECS Rails Runner

Run Rails commands against Spireworks ECS environments (staging/production) using `aws-vault` and `devenv shell`.

## Environments

| Environment | aws-vault profile | ECS cluster |
|---|---|---|
| Production | `spireworks` | `spireworks-production` |
| Staging | `dev-spireworks` | `spireworks-staging` |

Default to **production** unless the user specifies otherwise.

## Running Commands

### Rails runner (non-interactive, preferred for scripts)

```bash
devenv shell -- aws-vault exec <profile> -- ecs-exec --command "bundle exec rails runner \"<ruby_code>\""
```

Keep Ruby code on a single logical string. Use `+` for string concatenation inside `puts` (avoid interpolation issues with shell escaping). Escape inner double quotes.

### Rails console (interactive)

```bash
devenv shell -- aws-vault exec <profile> -- ecs-console
```

### Arbitrary shell command

```bash
devenv shell -- aws-vault exec <profile> -- ecs-exec --command "<command>"
```

## Patterns

### Querying records

```bash
devenv shell -- aws-vault exec spireworks -- ecs-exec --command "bundle exec rails runner \"
user = User.find_by(email: 'someone@example.com')
if user
  puts 'User: id=' + user.id.to_s + ' state=' + user.state.to_s + ' confirmed=' + user.confirmed?.to_s
else
  puts 'User: NOT FOUND'
end
\""
```

### Fuzzy search when exact value is uncertain

```bash
devenv shell -- aws-vault exec spireworks -- ecs-exec --command "bundle exec rails runner \"
results = Organizations::User.where('user_email ILIKE ?', '%partial%')
results.each { |r| puts r.id.to_s + ' ' + r.user_email.to_s }
\""
```

### Running a transaction/service

```bash
devenv shell -- aws-vault exec spireworks -- ecs-exec --command "bundle exec rails runner \"
result = SomeService.new.call(param: 'value')
puts result.success? ? 'OK' : result.failure.inspect
\""
```

## Guidelines

- Always use `devenv shell --` as the outer wrapper so ECS scripts are available.
- Use `rails runner` for one-off commands; it boots Rails, runs the script, and exits cleanly.
- Prefer `rails runner` over `rails console` for automated/scripted operations.
- Use string concatenation with `+` and `.to_s` for output. Avoid `#{}` interpolation to prevent shell escaping issues.
- Keep scripts idempotent when possible, especially for write operations.
- For destructive or write operations, confirm with the user before executing.
- Output is interleaved with Datadog/deprecation warnings; the actual script output appears near the end, before the "Exiting session" line.
- Commands that take longer than 30 seconds may need a higher `block_until_ms` (120000 is a safe default).
