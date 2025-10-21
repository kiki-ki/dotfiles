#!/usr/bin/env sh

set -eu

echo "🚀 Starting dotfiles setup..."

local dotfiles_repo="kiki-ki/dotfiles"
local os_type="$(uname)"
local type=""

if [ "$os_name" = "Darwin" ]; then
  type="macos"
elif [ "$os_name" = "Linux" ]; then
  type="ubuntu"
  if command -v curl >/dev/null 2>&1; then
    sudo apt-get update && sudo apt-get install -y curl
  fi
else
  echo "error: Unsupported OS: ${os_name}"
  exit 1
fi

echo "Installing dotfiles from repository: ${dotfiles_repo}"
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply "$dotfiles_repo"

echo "Running ${type} installation script..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/${dotfiles_repo}/main/install/${type}.sh)"

echo "✅ Setup completed!"
