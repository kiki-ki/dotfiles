#!/bin/bash
# shellcheck shell=bash

# local bin setting
LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"
export PATH="$LOCAL_BIN:$PATH"

if ! sudo -v; then
  echo "sudo access required."
  exit 1
else
  echo "🚀 start: setup for ubuntu..."

  ARCH=$(uname -m)

  sudo apt-get update
  sudo apt-get install -y \
    build-essential \
    curl \
    file \
    git \
    gpg \
    grep \
    less \
    lsof \
    procps \
    unzip \
    vim \
    zsh

  # mise
  if ! command -v mise >/dev/null 2>&1; then
    sudo install -dm 755 /etc/apt/keyrings
    curl -fSs https://mise.jdx.dev/gpg-key.pub | sudo tee /etc/apt/keyrings/mise-archive-keyring.asc 1>/dev/null
    echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.asc] https://mise.jdx.dev/deb stable main" | sudo tee /etc/apt/sources.list.d/mise.list
    sudo apt-get update -y
    sudo apt-get install -y mise
  fi
  export PATH="$HOME/.local/share/mise/shims:$PATH"
  mise install

  # shell
  if command -v zsh >/dev/null 2>&1; then
    if [ "$SHELL" != "$(command -v zsh)" ]; then
       sudo chsh -s "$(command -v zsh)" "$(whoami)"
    fi
  fi

  # eza
  if ! command -v eza >/dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 -fL "https://github.com/eza-community/eza/releases/latest/download/eza_$ARCH-unknown-linux-gnu.tar.gz" | tar xz -C "$LOCAL_BIN"
    chmod +x "$LOCAL_BIN/eza"
  fi

  # claude code
  if ! command -v claude >/dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 -fsSL https://claude.ai/install.sh | env DOWNLOAD_DIR="$LOCAL_BIN" bash
  fi

  echo "✅ completed: setup for ubuntu"
fi
