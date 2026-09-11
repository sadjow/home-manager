# Local Codex UI routing

## Scope

Apply this preference to local Codex tasks in the ChatGPT/Codex desktop app.
Apply it in a local Codex CLI session only when that session actually exposes
the native computer-use integration for the required app or browser. Ordinary
CLI sessions do not inherit the desktop app's tools.

Use the execution context, callable tools, and their documented supported
surfaces as evidence. In the current desktop integration, `mcp__cua_repl`
provides native app and browser control through `unified-computer-use`.
The model name, plugin installation, or a screenshot alone does not establish
that the current session can control the target.

This preference does not apply to ChatGPT tasks running in a web browser,
ChatGPT Work cloud tasks, Codex cloud tasks, remote browser environments, or
other coding agents. Follow those environments' available tools and routing.
The desktop app's built-in browser is a local surface and remains in scope.

## Choose by task

Honor an explicit tool, browser, profile, or tab choice within its supported
scope. Naming Chrome chooses the browser, not browser-harness as the controller.
Prefer a suitable skill, connector, API, or CLI for structured work when the
task does not depend on UI interaction or the user's live session.

For UI work in an eligible local session, use the following preference. Select
a native route only when its required surface is enabled and callable.

| Task | Preferred route |
| --- | --- |
| Operate a native desktop app or work across app windows | Enabled native Computer Use for the target app |
| Work in an existing signed-in browser session or mentioned tab | Native browser control for that browser/profile, such as `@Chrome` |
| Interact with a hosted editor, inspect a localhost page, or perform exploratory development and QA checks | Native browser control; use the built-in browser when no existing session is needed |
| Write or run repository-owned end-to-end tests, reproduce a failure with assertions, or debug automated tests | Project Playwright workflow in an isolated test context |
| Browser work when native control is unavailable or lacks a required capability | Return to the shared browser-harness defaults, respecting session needs and explicit choices |

## Combine tools during development and QA

Choose tools per check in both development and QA. Native Computer Use can
support exploratory interaction, visual review, bug investigation, and checking
a fix while Playwright supplies scripted reproduction, assertions,
and repeatable regression coverage. These routes are complementary; a phase
label does not make one tool exclusive.

Combine them when each adds useful evidence. For example, investigate a UI bug
with native control, capture a focused regression in the project's test suite,
then verify the fix through both the automated check and a visual walkthrough.
Follow the project's regression workflow. A request only to run the test suite
does not require an additional native walkthrough, and exploratory QA alone
does not require introducing a new test framework.

Keep test code in the repository and use its test accounts and fixtures. A
native walkthrough or Playwright MCP session alone does not create committed
test coverage. When switching controllers on a shared app or tab, finish the
current interaction and observe the state again before proceeding; avoid
simultaneous control of that surface.

## Use the selected integration

Follow the native tool's current bootstrap and API documentation. Its app,
browser, and tab selection rules are authoritative; do not translate the CDP
recipes in the parent skill into native calls. Use the native browser surface
for browser work and the app surface for desktop apps. Verify the outcome with
fresh UI observations through the selected tool.

Keep the selected session: the built-in browser, regular Chrome profile,
Playwright context, and cloud browser have separate state. Do not export
credentials or cookies to make another route appear equivalent.

Use browser-harness as a capability fallback, not to bypass denied access,
website restrictions, or an approval requirement. A request for native UI
control that cannot be fulfilled needs a brief limitation report before a
materially different workflow. Do not install an integration or enable remote
debugging merely because the native tool was not immediately visible. Discover
available tools first; retain the user's existing authorization for permitted
actions without inventing additional confirmation steps.

## Authentication across apps

When the user authorizes retrieving a login code from Messages or an available
phone-mirroring app, carry that authorization through the current sign-in flow.
Use the authorized app before asking the user to transcribe the code. Prefer
Messages when it already exposes the relevant SMS; discover phone mirroring
only when needed and never assume that an iPhone is connected or controllable.
Reading a code does not authorize replying to its sender or using it for a
different service, account, password reset, or transaction.

Match the sender, request time, and intended destination before using a code.
Keep codes and credentials out of commentary, artifacts, harness files, and
memory. Where supported, inspect only the relevant conversation and suppress
or redact authentication values in tool output. Transfer the current code
directly into the authorized service and verify successful authentication.

Distinguish code delivery from the receiving form's state. If a code arrives
but the page never exposes its entry fields, diagnose that UI transition;
do not repeatedly resend codes or ask the user for a code already available.
After a bounded wait and an observed-UI recovery attempt, report the actual
blocker. A retry must account for whether it invalidates the previous code.

Preserve the active tab with the tool's documented handoff or deliverable
mechanism before ending a turn that needs continuation. Verify its existence
on return; a preservation request is not proof that the tab survived. Reuse
the existing sign-in flow when possible rather than restarting authentication.

Apply the live tool's confirmation modes separately from login authorization.
Reuse consent where its contract permits, but do not convert standing user
approval into an exception to an action-time confirmation or handoff rule.

## Basis and maintenance

This is a personal routing preference based on task fit and the current tool
contract, not a benchmark claim or a minimum-model requirement. GPT-6 Astra
motivated the review; availability of the needed integration determines the
route. OpenAI's API recommendation for code execution also includes Playwright
implementations, so it does not establish that all computer use replaces
Playwright.

Sources checked on 2026-09-04:

- [Computer Use](https://learn.chatgpt.com/docs/computer-use) documents desktop
  app control and its operating boundaries.
- [Browser extension](https://learn.chatgpt.com/docs/chrome-extension) documents
  existing browser sessions and explicit browser selection.
- [Browser](https://learn.chatgpt.com/docs/browser) distinguishes the local
  built-in browser, CLI availability, and separate cloud browser state.
- [Computer use API](https://developers.openai.com/api/docs/guides/tools-computer-use)
  describes code execution and existing UI tool integrations.
- [Playwright best practices](https://playwright.dev/docs/best-practices) supports
  isolated tests, assertions, traces, and CI.
