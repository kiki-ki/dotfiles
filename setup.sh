#!/usr/bin/env sh

set -eu

echo "🚀 Starting dotfiles setup..."

dotfiles_repo="kiki-ki/dotfiles"
os_type="$(uname)"
type=""

if [ "$os_type" = "Darwin" ]; then
  type="macos"
elif [ "$os_type" = "Linux" ]; then
  type="ubuntu"
  # curl がなければインストール
  if ! command -v curl >/dev/null 2>&1; then
    echo "Installing curl..."
    sudo apt-get update && sudo apt-get install -y curl
  fi
else
  echo "error: Unsupported OS: ${os_type}"
  exit 1
fi

echo "Installing dotfiles from repository: ${dotfiles_repo}"
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply "$dotfiles_repo"

echo "Running ${type} installation script..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/${dotfiles_repo}/main/install/${type}.sh)"

echo "✅ Setup completed!"
