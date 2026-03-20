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
brew bundle --file=~/.config/Brewfile --cleanup

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

vscode_source_dir="$HOME/.config/vscode"
vscode_deploy_dir="$HOME/Library/Application Support/Code/User/"

mkdir -p "$vscode_deploy_dir"
cat "$vscode_source_dir"/settings.json > "$vscode_deploy_dir"/settings.json
cat "$vscode_source_dir"/keybindings.json > "$vscode_deploy_dir"/keybindings.json

# Install declared extensions
declared_extensions=()
while read -r line; do
  if [ -n "$line" ]; then
    code --install-extension "$line" --force || true
    declared_extensions+=("$(echo "$line" | tr '[:upper:]' '[:lower:]')")
  fi
done < "$vscode_source_dir"/extensions.txt

# Uninstall extensions not in the list
while read -r ext; do
  ext_lower="$(echo "$ext" | tr '[:upper:]' '[:lower:]')"
  found=false
  for d in "${declared_extensions[@]}"; do
    if [ "$d" = "$ext_lower" ]; then
      found=true
      break
    fi
  done
  if [ "$found" = false ]; then
    echo "Uninstalling unlisted extension: $ext"
    code --uninstall-extension "$ext" || true
  fi
done < <(code --list-extensions)

echo "completed: vscode settings"

echo "✅ completed: setup for macOS"

