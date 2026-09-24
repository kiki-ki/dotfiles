#!/bin/bash
# shellcheck shell=bash

echo "🚀 start: setup for macOS..."

if [ "$SHELL" != "$(command -v zsh)" ]; then
  chsh -s "$(command -v zsh)"
fi

### Homebrew ###

echo "start: install homebrew and packages"

if ! xcode-select -p 1>/dev/null; then
  xcode-select --install
fi
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

brew update
# Reruns on any dot_config change, where upgrades can mean hours of source builds
brew bundle install --no-upgrade --file=~/.config/Brewfile

if ! command -v claude >/dev/null 2>&1; then
  curl -fsSL https://claude.ai/install.sh | bash
fi

# Upstream ships prebuilt binaries. The Homebrew formula has no bottle for this
# configuration and would build mise from source through rust and llvm, which
# takes hours.
export PATH="$HOME/.local/bin:$PATH"
if ! command -v mise >/dev/null 2>&1; then
  curl https://mise.run | sh
fi

echo "start: mise install"
mise install
echo "completed: mise install"

echo "completed: install homebrew and packages"

### MacOS Defaults settings ###

echo "start: set macOS defaults"

# Base
chflags nohidden ~/Library
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Finder
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true

echo "completed: set macOS defaults"

### VSCode settings ###

echo "start: vscode settings"

export NODE_NO_WARNINGS=1

vscode_source_dir="$HOME/.config/vscode"
vscode_deploy_dir="$HOME/Library/Application Support/Code/User/"

mkdir -p "$vscode_deploy_dir"
cat "$vscode_source_dir"/settings.json > "$vscode_deploy_dir"/settings.json
cat "$vscode_source_dir"/keybindings.json > "$vscode_deploy_dir"/keybindings.json

# Extensions are declared in the Brewfile and installed by `brew bundle` above.
# Scope the cleanup to --vscode so unlisted formulae and casks are left alone.
brew bundle cleanup --vscode --force --file=~/.config/Brewfile

echo "completed: vscode settings"

echo "✅ completed: setup for macOS"

