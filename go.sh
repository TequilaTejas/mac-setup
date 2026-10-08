#!/usr/bin/env bash
# One-line setup for a new Mac. Installs Homebrew + GitHub CLI, signs in to GitHub,
# clones the private TequilaTejas/claude-setup repo, and runs its installer.
set -euo pipefail
say() { printf "\n\033[1;36m==> %s\033[0m\n" "$1"; }

say "Developer tools (git)"
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install || true
  echo "A dialog opened. Click Install, then wait..."
  until xcode-select -p >/dev/null 2>&1; do sleep 10; done
fi

say "Homebrew (asks for your Mac password once)"
if ! command -v brew >/dev/null && [ ! -x /opt/homebrew/bin/brew ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"
grep -q 'brew shellenv' ~/.zprofile 2>/dev/null || echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile

say "GitHub sign-in (press Enter, then approve in the browser)"
command -v gh >/dev/null || brew install gh
gh auth status >/dev/null 2>&1 || gh auth login --hostname github.com --git-protocol https --web
gh auth setup-git

say "Fetching your setup"
mkdir -p ~/projects
if [ -d ~/projects/claude-setup/.git ]; then git -C ~/projects/claude-setup pull -q
else gh repo clone TequilaTejas/claude-setup ~/projects/claude-setup; fi

exec ~/projects/claude-setup/install.sh
