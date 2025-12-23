#!/bin/bash
set -eu

LOCAL_BIN="$HOME/.local/bin"

mkdir -p "$LOCAL_BIN"
export PATH="$LOCAL_BIN:$PATH"

if ! sudo -v; then
  echo "sudo access required."
  exit 1
else
  echo "🚀 start: setup for ubuntu..."

  sudo apt-get update
  sudo apt-get install -y curl gpg

  if [ ! -f /etc/apt/keyrings/charm.gpg ]; then
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor --yes -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
    sudo apt-get update
  fi

  sudo apt-get install -y \
    awscli \
    bat \
    build-essential \
    file \
    git \
    grep \
    gum \
    jq \
    less \
    lsof \
    procps \
    vim \
    zsh

  # bat
  if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
    ln -s "$(which batcat)" "$LOCAL_BIN/bat"
  fi

  # shell
  if command -v zsh >/dev/null 2>&1; then
    if [ "$SHELL" != "$(which zsh)" ]; then
       sudo chsh -s "$(which zsh)" "$(whoami)"
    fi
  fi

  # fzf
  if [ ! -d "$HOME/.fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --all
  fi

  # sheldon
  if ! command -v sheldon >/dev/null 2>&1; then
    curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh | bash -s -- --repo rossmacarthur/sheldon --to "$LOCAL_BIN"
  fi

  # uv
  if ! command -v uv >/dev/null 2>&1; then
    curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR="$LOCAL_BIN" sh
  fi

  # pnpm
  if ! command -v pnpm >/dev/null 2>&1; then
    curl -fsSL https://get.pnpm.io/install.sh | env PNPM_HOME="$LOCAL_BIN" sh -
  fi

  # starship
  if ! command -v starship >/dev/null 2>&1; then
    sh -c "$(curl -sS https://starship.rs/install.sh)" -- --yes --bin-dir "$LOCAL_BIN"
  fi

  # go-qo
  if ! command -v qo >/dev/null 2>&1; then
    curl -sfL https://raw.githubusercontent.com/kiki-ki/go-qo/main/install.sh | env BINDIR="$LOCAL_BIN" sh
  fi

  # eza
  if ! command -v eza >/dev/null 2>&1; then
    ARCH=$(uname -m)
    curl -fL "https://github.com/eza-community/eza/releases/latest/download/eza_$ARCH-unknown-linux-gnu.tar.gz" | tar xz -C "$LOCAL_BIN"
    chmod +x "$LOCAL_BIN/eza"
  fi

  # claude code
  if ! command -v claude >/dev/null 2>&1; then
    curl -fsSL https://claude.ai/install.sh | env DOWNLOAD_DIR="$LOCAL_BIN" bash
  fi

  if command -v pnpm >/dev/null 2>&1; then
    COREPACK_ENABLE_DOWNLOAD_PROMPT=0 pnpm config set --location=global minimumReleaseAge 4320
  fi
fi

