#!/usr/bin/env python3
"""Preflight and post one exact GitHub pull-request inline comment.

The command is read-only unless --execute is present. Execution also requires
the approval digest emitted by a previous preflight for the exact target and body.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import subprocess
import sys
from pathlib import Path
from typing import Any


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Preflight or post one exact GitHub PR inline comment."
    )
    parser.add_argument("--repo", required=True, help="GitHub repository as owner/name")
    parser.add_argument("--pr", required=True, type=int, help="Pull request number")
    parser.add_argument("--commit-sha", required=True, help="Expected current PR head SHA")
    parser.add_argument("--path", required=True, help="Repository-relative target path")
    parser.add_argument("--line", required=True, type=int, help="Target diff line number")
    parser.add_argument(
        "--side", choices=("LEFT", "RIGHT"), default="RIGHT", help="Diff side"
    )
    parser.add_argument("--body-file", required=True, type=Path, help="Exact UTF-8 body")
    parser.add_argument(
        "--execute", action="store_true", help="Post after all preflight checks"
    )
    parser.add_argument(
        "--approval-digest",
        help="Digest emitted by preflight for this exact target and body",
    )
    return parser.parse_args()


def fail(message: str, code: int = 1) -> None:
    print(f"ERROR: {message}", file=sys.stderr)
    raise SystemExit(code)


def run_gh(arguments: list[str], stdin: str | None = None) -> str:
    try:
        result = subprocess.run(
            ["gh", *arguments],
            input=stdin,
            text=True,
            capture_output=True,
            check=False,
        )
    except FileNotFoundError:
        fail("The gh CLI is not installed or is not on PATH.")

    if result.returncode != 0:
        detail = result.stderr.strip() or result.stdout.strip()
        fail(f"gh command failed: {detail}")
    return result.stdout


def load_body(path: Path) -> str:
    try:
        body = path.read_text(encoding="utf-8")
    except OSError as error:
        fail(f"Cannot read body file: {error}")

    body = body.rstrip("\n")
    if not body.strip():
        fail("The comment body is empty.")
    if "\x00" in body:
        fail("The comment body contains a NUL byte.")
    if len(body.encode("utf-8")) > 65_536:
        fail("The comment body exceeds 65,536 UTF-8 bytes.")
    return body


def validate_target(args: argparse.Namespace) -> None:
    if args.pr <= 0:
        fail("The pull request number must be positive.")
    if args.line <= 0:
        fail("The target line must be positive.")
    if not args.path or args.path == ".":
        fail("The target path cannot be empty.")
    if args.path.startswith("/") or ".." in Path(args.path).parts:
        fail("The target path must be repository-relative and cannot contain '..'.")
    if len(args.commit_sha) != 40 or any(
        character not in "0123456789abcdefABCDEF" for character in args.commit_sha
    ):
        fail("The commit SHA must contain exactly 40 hexadecimal characters.")
    if args.repo.count("/") != 1 or any(not part for part in args.repo.split("/")):
        fail("The repository must use the owner/name format.")


def current_pr(args: argparse.Namespace) -> dict[str, Any]:
    output = run_gh(
        [
            "pr",
            "view",
            str(args.pr),
            "--repo",
            args.repo,
            "--json",
            "headRefOid,state,url",
        ]
    )
    try:
        return json.loads(output)
    except json.JSONDecodeError as error:
        fail(f"Cannot parse PR metadata: {error}")


def existing_comments(args: argparse.Namespace) -> list[dict[str, Any]]:
    output = run_gh(
        [
            "api",
            "--paginate",
            "--slurp",
            f"repos/{args.repo}/pulls/{args.pr}/comments?per_page=100",
        ]
    )
    try:
        pages = json.loads(output)
    except json.JSONDecodeError as error:
        fail(f"Cannot parse existing comments: {error}")

    comments: list[dict[str, Any]] = []
    for page in pages:
        if isinstance(page, list):
            comments.extend(item for item in page if isinstance(item, dict))
    return comments


def changed_files(args: argparse.Namespace) -> list[dict[str, Any]]:
    output = run_gh(
        [
            "api",
            "--paginate",
            "--slurp",
            f"repos/{args.repo}/pulls/{args.pr}/files?per_page=100",
        ]
    )
    try:
        pages = json.loads(output)
    except json.JSONDecodeError as error:
        fail(f"Cannot parse changed files: {error}")

    files: list[dict[str, Any]] = []
    for page in pages:
        if isinstance(page, list):
            files.extend(item for item in page if isinstance(item, dict))
    return files


HUNK_HEADER = re.compile(
    r"^@@ -(\d+)(?:,(\d+))? \+(\d+)(?:,(\d+))? @@"
)


def line_belongs_to_patch(patch: str, line: int, side: str) -> bool:
    old_line: int | None = None
    new_line: int | None = None

    for patch_line in patch.splitlines():
        match = HUNK_HEADER.match(patch_line)
        if match:
            old_line = int(match.group(1))
            new_line = int(match.group(3))
            continue
        if old_line is None or new_line is None or patch_line.startswith("\\"):
            continue

        prefix = patch_line[:1]
        if prefix == " ":
            if (side == "LEFT" and old_line == line) or (
                side == "RIGHT" and new_line == line
            ):
                return True
            old_line += 1
            new_line += 1
        elif prefix == "-":
            if side == "LEFT" and old_line == line:
                return True
            old_line += 1
        elif prefix == "+":
            if side == "RIGHT" and new_line == line:
                return True
            new_line += 1

    return False


def validate_diff_target(args: argparse.Namespace) -> None:
    target = next(
        (item for item in changed_files(args) if item.get("filename") == args.path),
        None,
    )
    if target is None:
        fail(f"The target path is not in the current PR diff: {args.path}")

    patch = target.get("patch")
    if not isinstance(patch, str) or not patch:
        fail(
            "GitHub did not return the target file patch, so the line cannot be "
            "verified safely. Inspect the diff manually before posting."
        )
    if not line_belongs_to_patch(patch, args.line, args.side):
        fail(
            f"Line {args.line} on side {args.side} is not commentable in the "
            "current target-file diff."
        )


def approval_payload(args: argparse.Namespace, body: str) -> dict[str, Any]:
    return {
        "repo": args.repo,
        "pr": args.pr,
        "commit_id": args.commit_sha.lower(),
        "path": args.path,
        "line": args.line,
        "side": args.side,
        "body": body,
    }


def approval_digest(payload: dict[str, Any]) -> str:
    canonical = json.dumps(
        payload, ensure_ascii=False, sort_keys=True, separators=(",", ":")
    )
    return hashlib.sha256(canonical.encode("utf-8")).hexdigest()


def find_duplicate(
    comments: list[dict[str, Any]], args: argparse.Namespace, body: str
) -> dict[str, Any] | None:
    for comment in comments:
        line = comment.get("line") or comment.get("original_line")
        if (
            comment.get("path") == args.path
            and line == args.line
            and comment.get("body") == body
        ):
            return comment
    return None


def main() -> None:
    args = parse_args()
    validate_target(args)
    body = load_body(args.body_file)

    pr = current_pr(args)
    if pr.get("state") != "OPEN":
        fail(f"Pull request state is {pr.get('state')!r}, not OPEN.")
    current_head = str(pr.get("headRefOid", "")).lower()
    if current_head != args.commit_sha.lower():
        fail(
            "The PR head changed. "
            f"Expected {args.commit_sha.lower()}, current {current_head or 'unknown'}."
        )

    validate_diff_target(args)
    duplicate = find_duplicate(existing_comments(args), args, body)
    if duplicate:
        url = duplicate.get("html_url") or duplicate.get("url") or "unknown URL"
        fail(f"An identical comment already exists: {url}", code=3)

    payload = approval_payload(args, body)
    digest = approval_digest(payload)
    print(json.dumps({"target": payload, "approval_digest": digest}, indent=2))

    if not args.execute:
        print("PREFLIGHT ONLY: no comment was posted.")
        return

    if not args.approval_digest:
        fail("--execute requires --approval-digest from the approved preflight.")
    if args.approval_digest.lower() != digest:
        fail("The approval digest does not match the current target and body.")

    final_pr = current_pr(args)
    final_head = str(final_pr.get("headRefOid", "")).lower()
    if final_pr.get("state") != "OPEN" or final_head != args.commit_sha.lower():
        fail("The PR state or head changed after preflight. No comment was posted.")
    duplicate = find_duplicate(existing_comments(args), args, body)
    if duplicate:
        url = duplicate.get("html_url") or duplicate.get("url") or "unknown URL"
        fail(f"An identical comment appeared before posting: {url}", code=3)

    api_payload = {
        "body": body,
        "commit_id": args.commit_sha,
        "path": args.path,
        "line": args.line,
        "side": args.side,
    }
    response = run_gh(
        [
            "api",
            "--method",
            "POST",
            f"repos/{args.repo}/pulls/{args.pr}/comments",
            "--input",
            "-",
        ],
        stdin=json.dumps(api_payload, ensure_ascii=False),
    )
    try:
        posted = json.loads(response)
    except json.JSONDecodeError as error:
        fail(f"GitHub returned an unreadable posting response: {error}")

    result = {"id": posted.get("id"), "url": posted.get("html_url")}
    if not result["id"] or not result["url"]:
        fail("GitHub did not return both a comment ID and URL. Inspect before retrying.")
    print(json.dumps({"posted": result}, indent=2))


if __name__ == "__main__":
    main()
