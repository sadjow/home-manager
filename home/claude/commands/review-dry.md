---
description: Scan code for DRY/SSOT violations - duplicate values, repeated configuration, and magic numbers
argument-hint: [file-or-directory]
---

Perform a focused DRY/SSOT violation scan on $ARGUMENTS.

## Your Task

Identify violations of the DRY (Don't Repeat Yourself) and SSOT (Single Source of Truth) principles:

### Look For

1. **Duplicate Values**: Same constant/configuration value appearing in multiple files
   - Example: `const TIMEOUT = 5000` in file1.js and file2.js

2. **Magic Numbers/Strings**: Unexplained literals that should be named constants
   - Example: `setTimeout(callback, 5000)` instead of using `TIMEOUT`

3. **Repeated Configuration**: Same config appearing in different locations
   - API URLs, feature flags, timeouts, retry counts

4. **Duplicated Business Logic**: Same calculation or rule in multiple places
   - Tax calculations, discount formulas, validation rules

5. **Copied Code**: Similar code blocks doing the same thing

### Report Format

For each violation found, report:

1. **Type**: (Duplicate Value | Magic Number | Repeated Config | Duplicated Logic | Copied Code)
2. **Locations**: List all files and line numbers where it appears
3. **Value/Pattern**: What is duplicated
4. **Impact**: How many changes required if this value/logic needs to update
5. **Fix**: Suggest single source location (e.g., "Extract to config/constants.js")

### SSOT Principle Reminder

"Every piece of knowledge must have a single, unambiguous, authoritative representation within a system" - The Pragmatic Programmer

When you change a value, you should only need to modify ONE location.

### Output

Provide a prioritized list:
- **Critical**: Values that exist in 3+ places
- **High**: Values that exist in 2 places and likely to change
- **Medium**: Magic numbers that should be constants

Do NOT refactor the code - just identify and report violations. The user will decide how to proceed.
