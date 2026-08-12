---
description: Add or improve documentation in Elixir files following best practices
allowed-tools: Read, Edit, Grep, Glob
---

Add or improve documentation for Elixir modules and functions following Elixir documentation best practices.

## Your Task

1. **Analyze the target**: If a file path is provided, read it. Otherwise, ask which file to document
2. **Identify undocumented code**: Find modules/functions missing `@moduledoc`, `@doc`, or `@spec`
3. **Review existing docs**: Check if existing documentation follows best practices
4. **Add/improve documentation**: Following the guidelines below
5. **Verify**: Ensure documentation is clear, concise, and follows conventions

## Elixir Documentation Best Practices

### First Line is Critical
- Keep the first line **concise and simple** - ideally one sentence
- Tools like ExDoc use this for summaries
- Clearly state what the module/function does

### Structure
```elixir
@doc """
Brief one-line summary.

Optional longer explanation if needed. Keep focused.

## Parameters
  - name: Description of parameter
  - opts: Keyword list options

## Examples

    iex> Module.function("test")
    :ok

    iex> Module.function("invalid")
    {:error, :invalid}

## Options
  - `:key` - description (default: value)
"""
@spec function(String.t(), keyword()) :: :ok | {:error, atom()}
def function(name, opts \\ [])
```

### Language Guidelines

**Be Direct**:
- Use imperative mood: "Returns", "Validates", "Creates"
- Avoid: "This function will...", "Used to..."

**Be Specific**:
```elixir
# ✅ Good
"Converts UTC timestamp to user's local timezone"

# ❌ Bad
"Handles time conversion"
```

**Avoid Redundancy**:
```elixir
# ✅ Good
@doc "Validates email format."
def validate_email(email)

# ❌ Bad
@doc "Validates the email."
def validate_email(email)
```

### Module Documentation Template
```elixir
defmodule MyApp.Service do
  @moduledoc """
  Handles service operations for the application.

  Longer description explaining the module's purpose,
  key concepts, or usage patterns.

  ## Examples

      iex> Service.start()
      {:ok, pid}
  """
end
```

### Function Documentation Requirements

**Always include**:
1. One-line summary (first line)
2. `@spec` type specification
3. Examples with `iex>` prefix (they become doctests)
4. Parameter descriptions (if not obvious)
5. Options documentation (for keyword lists)

**Use proper references**:
- Local functions: `` `function_name/arity` ``
- External functions: `` `Module.function_name/arity` ``
- Modules: `` `MyApp.Module` ``
- Callbacks: `` `c:callback_name/1` ``
- Types: `` `t:type_name/0` ``

### Examples Section
```elixir
## Examples

    iex> Math.add(2, 3)
    5

    iex> Math.divide(10, 0)
    {:error, :division_by_zero}
```

### Metadata
Add when relevant:
```elixir
@doc since: "1.2.0"
@doc deprecated: "Use new_function/2 instead"
```

## Critical Rules

1. **First line matters** - make it count
2. **Examples are mandatory** - they become tests
3. **Be concise** - respect your readers' time
4. **Use full module names** - enable auto-linking
5. **Always pair @doc with @spec** - type safety
6. **Clear language** - no jargon, direct statements
7. **Consistent structure** - Parameters, Examples, Options

## Output

After documenting:
1. Show what you documented
2. Verify examples would work as doctests
3. Confirm `@spec` matches function signature
