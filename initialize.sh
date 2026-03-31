#!/usr/bin/env bash
set -euo pipefail

dotnet tool install --global autosdk.cli --prerelease

autosdk init \
  SolutionName \
  SomeClient \
  https://raw.githubusercontent.com/api/openapi.json \
  CompanyName \
  --output .

if command -v gh >/dev/null 2>&1; then
  current_repo="$(gh repo view --json nameWithOwner --jq .nameWithOwner 2>/dev/null || true)"

  if [ -n "$current_repo" ]; then
    gh repo edit "$current_repo" \
      --allow-update-branch \
      --enable-auto-merge \
      --delete-branch-on-merge
  else
    echo "GitHub repository not detected. After creating it, run:"
    echo "gh repo edit OWNER/REPO --allow-update-branch --enable-auto-merge --delete-branch-on-merge"
  fi
fi
