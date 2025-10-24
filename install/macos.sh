#!/bin/sh

if [ "$(uname)" != "Darwin" ] ; then
	echo "error: Only Darwin OS is suppoted."
	exit 1
fi

chsh -s /bin/zsh

xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# MacOS Defaults settings

## Base

sudo chflags nohidden ~/Library
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

## Finder

defaults write -g ApplePressAndHoldEnabled -bool false
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true

## Init

brew bundle --file=~/.config/Brewfile
. ~/.zshrc

## VSCode

init_settings () {
  local source_dir="$HOME"/.config/vscode
  local deploy_dir="$HOME"/Library/Application\ Support/Code/User/

  cat "$source_dir"/settings.json > "$deploy_dir"/settings.json
  cat "$source_dir"/keybindings.json > "$deploy_dir"/keybindings.json

  while read -r line; do code --install-extension "$line"; done < "$source_dir"/extensions.txt
}

echo "VSCode settings overwrite current VSCode settings, OK? [Yy/n]: "
read -r yn

if [ ! "$yn" = "Y" ] && [ ! "$yn" = "y" ]; then
  echo "canceled."
  exit 1
fi

init_settings
echo "init vscode settings completed."
