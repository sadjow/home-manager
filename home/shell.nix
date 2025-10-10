{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    profileExtra = ''
      # Add Dart pub global packages to PATH
      export PATH="$HOME/.pub-cache/bin:$PATH"

      # Ensure direnv is available in login shells (like VSCode/Cursor terminals)
      if command -v direnv >/dev/null 2>&1; then
        eval "$(direnv hook zsh)"
      fi
    '';
    initContent = ''
      . ${pkgs.asdf-vm}/share/asdf-vm/asdf.sh

      # GitHub PR Review Functions

      # Helper function to get current repo owner and name
      gh-repo-info() {
        local remote_url=$(git config --get remote.origin.url 2>/dev/null)
        if [[ -z "$remote_url" ]]; then
          echo "Error: Not in a git repository" >&2
          return 1
        fi

        # Extract owner/repo from various URL formats
        # Handle SSH format: git@github.com:owner/repo.git
        if [[ "$remote_url" =~ github\.com:([^/]+)/([^/]+)(\.git)?$ ]]; then
          echo "''${match[1]}/''${match[2]%.git}"
        # Handle HTTPS format: https://github.com/owner/repo.git
        elif [[ "$remote_url" =~ github\.com/([^/]+)/([^/]+)(\.git)?$ ]]; then
          echo "''${match[1]}/''${match[2]%.git}"
        else
          echo "Error: Could not parse GitHub repository from remote URL: $remote_url" >&2
          return 1
        fi
      }

      # Get PR number from current branch or use provided argument
      gh-pr-number() {
        local pr_number="$1"
        if [[ -z "$pr_number" ]]; then
          # Try to get PR number for current branch
          pr_number=$(gh pr view --json number -q .number 2>/dev/null)
          if [[ -z "$pr_number" ]]; then
            echo "Error: No PR found for current branch and no PR number provided" >&2
            echo "Usage: gh-pr-* [PR_NUMBER]" >&2
            return 1
          fi
        fi
        echo "$pr_number"
      }

      # Fetch all review comments on a PR
      gh-pr-comments() {
        local pr_number=$(gh-pr-number "$1")
        [[ -z "$pr_number" ]] && return 1

        local repo=$(gh-repo-info)
        [[ -z "$repo" ]] && return 1

        echo "📝 Fetching review comments for PR #$pr_number..."
        gh api "repos/$repo/pulls/$pr_number/comments" --paginate | \
          jq -r '.[] | "[\(.user.login)] \(.path):\(.line // .original_line) - \(.body | split("\n")[0])"'
      }

      # Get all reviews on a PR
      gh-pr-reviews() {
        local pr_number=$(gh-pr-number "$1")
        [[ -z "$pr_number" ]] && return 1

        local repo=$(gh-repo-info)
        [[ -z "$repo" ]] && return 1

        echo "👁 Fetching reviews for PR #$pr_number..."
        gh api "repos/$repo/pulls/$pr_number/reviews" --paginate | \
          jq -r '.[] | "[\(.user.login)] \(.state) - \(.body // "No comment" | split("\n")[0])"'
      }

      # Get review threads with resolution status
      gh-pr-threads() {
        local pr_number=$(gh-pr-number "$1")
        [[ -z "$pr_number" ]] && return 1

        local repo=$(gh-repo-info)
        [[ -z "$repo" ]] && return 1

        # Split repo into owner and name
        local owner="''${repo%%/*}"
        local repo_name="''${repo##*/}"

        echo "🧵 Fetching review threads for PR #$pr_number..."

        gh api graphql -f query='
          query($owner: String!, $repo: String!, $number: Int!) {
            repository(owner: $owner, name: $repo) {
              pullRequest(number: $number) {
                reviewThreads(first: 100) {
                  nodes {
                    id
                    isResolved
                    path
                    line
                    comments(first: 10) {
                      nodes {
                        body
                        author { login }
                        createdAt
                      }
                    }
                  }
                }
              }
            }
          }' \
          -f owner="$owner" \
          -f repo="$repo_name" \
          -F number="$pr_number" | \
          jq -r '.data.repository.pullRequest.reviewThreads.nodes[] |
            "[\(if .isResolved then "✅ RESOLVED" else "❌ UNRESOLVED" end)] \(.path):\(.line) - \(.comments.nodes[0].author.login): \(.comments.nodes[0].body | split("\n")[0])"'
      }

      # Show only unresolved review threads
      gh-pr-unresolved() {
        local pr_number=$(gh-pr-number "$1")
        [[ -z "$pr_number" ]] && return 1

        local repo=$(gh-repo-info)
        [[ -z "$repo" ]] && return 1

        local owner="''${repo%%/*}"
        local repo_name="''${repo##*/}"

        echo "❌ Fetching unresolved review threads for PR #$pr_number..."

        local result=$(gh api graphql -f query='
          query($owner: String!, $repo: String!, $number: Int!) {
            repository(owner: $owner, name: $repo) {
              pullRequest(number: $number) {
                reviewThreads(first: 100) {
                  nodes {
                    id
                    isResolved
                    path
                    line
                    comments(first: 10) {
                      nodes {
                        body
                        author { login }
                        createdAt
                      }
                    }
                  }
                }
              }
            }
          }' \
          -f owner="$owner" \
          -f repo="$repo_name" \
          -F number="$pr_number" | \
          jq -r '.data.repository.pullRequest.reviewThreads.nodes[] |
            select(.isResolved == false) |
            "\(.path):\(.line) - \(.comments.nodes[0].author.login): \(.comments.nodes[0].body | split("\n")[0])"')

        if [[ -z "$result" ]]; then
          echo "✨ All review threads are resolved!"
        else
          echo "$result"
        fi
      }

      # Show only resolved review threads
      gh-pr-resolved() {
        local pr_number=$(gh-pr-number "$1")
        [[ -z "$pr_number" ]] && return 1

        local repo=$(gh-repo-info)
        [[ -z "$repo" ]] && return 1

        local owner="''${repo%%/*}"
        local repo_name="''${repo##*/}"

        echo "✅ Fetching resolved review threads for PR #$pr_number..."

        gh api graphql -f query='
          query($owner: String!, $repo: String!, $number: Int!) {
            repository(owner: $owner, name: $repo) {
              pullRequest(number: $number) {
                reviewThreads(first: 100) {
                  nodes {
                    id
                    isResolved
                    path
                    line
                    comments(first: 10) {
                      nodes {
                        body
                        author { login }
                        createdAt
                      }
                    }
                  }
                }
              }
            }
          }' \
          -f owner="$owner" \
          -f repo="$repo_name" \
          -F number="$pr_number" | \
          jq -r '.data.repository.pullRequest.reviewThreads.nodes[] |
            select(.isResolved == true) |
            "\(.path):\(.line) - \(.comments.nodes[0].author.login): \(.comments.nodes[0].body | split("\n")[0])"'
      }

      # Get PR review status summary
      gh-pr-status() {
        local pr_number=$(gh-pr-number "$1")
        [[ -z "$pr_number" ]] && return 1

        local repo=$(gh-repo-info)
        [[ -z "$repo" ]] && return 1

        local owner="''${repo%%/*}"
        local repo_name="''${repo##*/}"

        echo "📊 Review Status for PR #$pr_number"
        echo "================================"

        local stats=$(gh api graphql -f query='
          query($owner: String!, $repo: String!, $number: Int!) {
            repository(owner: $owner, name: $repo) {
              pullRequest(number: $number) {
                title
                state
                reviewDecision
                reviews(last: 10) {
                  totalCount
                  nodes {
                    state
                    author { login }
                  }
                }
                reviewThreads(first: 100) {
                  totalCount
                  nodes {
                    isResolved
                  }
                }
              }
            }
          }' \
          -f owner="$owner" \
          -f repo="$repo_name" \
          -F number="$pr_number")

        echo "$stats" | jq -r '.data.repository.pullRequest |
          "Title: \(.title)\nState: \(.state)\nReview Decision: \(.reviewDecision // "PENDING")"'

        echo ""
        echo "Review Threads:"
        echo "$stats" | jq -r '.data.repository.pullRequest.reviewThreads |
          "  Total: \(.totalCount)\n  Resolved: \([.nodes[] | select(.isResolved == true)] | length)\n  Unresolved: \([.nodes[] | select(.isResolved == false)] | length)"'

        echo ""
        echo "Reviews:"
        echo "$stats" | jq -r '.data.repository.pullRequest.reviews.nodes[] |
          "  [\(.state)] \(.author.login)"'
      }

      # Help function for GitHub PR commands
      gh-pr-help() {
        echo "GitHub PR Review Commands:"
        echo "  gh-pr-comments [PR]  - Fetch all review comments"
        echo "  gh-pr-reviews [PR]   - Get all reviews"
        echo "  gh-pr-threads [PR]   - Get review threads with resolution status"
        echo "  gh-pr-unresolved [PR] - Show only unresolved threads"
        echo "  gh-pr-resolved [PR]  - Show only resolved threads"
        echo "  gh-pr-status [PR]    - Get review status summary"
        echo ""
        echo "If PR number is omitted, uses current branch's PR"
      }
    '';
    shellAliases = {
      # Flutter development aliases
      flutter = "fvm flutter";
      dart = "fvm dart";
      f = "fvm flutter";
      d = "fvm dart";

      # GitHub PR review aliases
      gpr = "gh pr view --comments";  # Quick PR view with comments
      gpru = "gh-pr-unresolved";       # Show unresolved review threads
      gprs = "gh-pr-status";           # Show PR review status summary
      gprt = "gh-pr-threads";          # Show all review threads
      gprc = "gh-pr-comments";         # Show all review comments
      gprr = "gh-pr-reviews";          # Show all reviews
      gprh = "gh-pr-help";             # Show help for PR commands
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.bash = {
    enable = true;
    profileExtra = ''
      # Add Dart pub global packages to PATH
      export PATH="$HOME/.pub-cache/bin:$PATH"

      # Ensure direnv works for editors that might use bash
      if command -v direnv >/dev/null 2>&1; then
        eval "$(direnv hook bash)"
      fi
    '';
  };

  # Enable direnv bash integration
  programs.direnv.enableBashIntegration = true;
}