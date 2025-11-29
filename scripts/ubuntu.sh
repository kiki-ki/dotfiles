#!/bin/bash
set -eu

if ! sudo -v; then
  echo "sudo access required."
  exit 1
else
  sudo apt-get update
  sudo apt-get install -y curl gpg

  sudo mkdir -p /etc/apt/keyrings # set apt repository list
  curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
  echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list # charm repository for gum

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

  if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
    sudo ln -s "$(which batcat)" /usr/local/bin/bat
  fi

  # shell
  if command -v zsh >/dev/null 2>&1; then
    sudo chsh -s "$(which zsh)" "$(whoami)"
  fi

  # fzf
  if [ ! -d "$HOME/.fzf" ]; then
    sudo git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    sudo "$HOME/.fzf/install" --all
  fi

  # install other tools
  sudo env UV_INSTALL_DIR="/usr/bin" sh -c "$(curl -LsSf https://astral.sh/uv/install.sh)"
  sudo env PNPM_HOME="/usr/bin" sh -c "$(curl -LsSf https://get.pnpm.io/install.sh)"
  sudo sh -c "$(curl -sS https://starship.rs/install.sh)" -- --yes --bin-dir /usr/bin
  curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh | sudo bash -s -- --repo rossmacarthur/sheldon --to /usr/bin
  curl -L "https://github.com/eza-community/eza/releases/latest/download/eza_aarch64-unknown-linux-gnu.tar.gz" | sudo tar xz -C /usr/bin/
  sudo chmod +x /usr/bin/eza
  sudo env BINDIR="/usr/bin" sh -c "$(curl -fsLS get.chezmoi.io)"

  if command -v pnpm >/dev/null 2>&1; then
    COREPACK_ENABLE_DOWNLOAD_PROMPT=0 pnpm config set --location=global minimumReleaseAge 4320 # 3days
  fi
fi
