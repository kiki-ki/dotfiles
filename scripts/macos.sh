#!/bin/bash
set -eu

echo "🚀 start: setup for macOS..."

if [ "$SHELL" != "$(which zsh)" ]; then
  chsh -s "$(which zsh)"
fi

### Homebrew ###

echo "start: install homebrew and packages"

if ! xcode-select -p 1>/dev/null; then
  xcode-select --install
fi
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

brew bundle --file=~/.config/Brewfile

echo "completed: install homebrew and packages"

### MacOS Defaults settings ###

echo "start: set macOS defaults"

# Base
sudo chflags nohidden ~/Library
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Finder
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true

echo "completed: set macOS defaults"

### VSCode settings ###

vscode_settings () {
  local source_dir="$HOME/.config/vscode"
  local deploy_dir="$HOME/Library/Application Support/Code/User/"

  mkdir -p "$deploy_dir"
  cat "$source_dir"/settings.json > "$deploy_dir"/settings.json
  cat "$source_dir"/keybindings.json > "$deploy_dir"/keybindings.json

  while read -r line; do
    if [ -n "$line" ]; then
      code --install-extension "$line" --force || true
    fi
  done < "$source_dir"/extensions.txt
}

echo "start: vscode settings"
vscode_settings
echo "completed: vscode settings"

echo "✅ completed: setup for macOS"
