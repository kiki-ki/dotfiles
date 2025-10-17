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

## Install tools

git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ~/.zsh/zsh-autocomplete
brew bundle --global

## Init

. ~/.zshrc

