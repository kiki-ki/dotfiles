#! /usr/bin/env sh

set -eu

if [ "$(sudo echo hi)" != hi ]; then
  echo "Cannot use sudo."
else
  # setup for eza installation
  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
  sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list

  # install apt packages
  sudo apt-get update && sudo apt-get install -y \
    awscli \
    bat \
    build-essential \
    curl \
    eza \
    file \
    fzf \
    git \
    grep \
    jq \
    less \
    procps \
    vim \
    zsh \
    openssh-server

  # ssd setting
  sudo mkdir /var/run/sshd
  sudo /usr/sbin/sshd

  # install other tools
  sudo env BINDIR="/usr/bin" sh -c "$(curl -fsLS get.chezmoi.io)"
  sudo env UV_INSTALL_DIR="/usr/bin" sh -c "$(curl -LsSf https://astral.sh/uv/install.sh)"
  sudo env PNPM_HOME="/usr/bin" sh -c "$(curl -LsSf https://get.pnpm.io/install.sh)"
  sudo env BIN_DIR="/usr/bin" sh -c "$(curl -sS https://starship.rs/install.sh)"
  curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh | sudo bash -s -- --repo rossmacarthur/sheldon --to /usr/bin

  if command -v pnpm >/dev/null 2>&1; then
    pnpm config set --location=global minimumReleaseAge 4320 # 3days
  fi

  # shell
  if command -v zsh >/dev/null 2>&1; then
    sudo chsh -s $(which zsh) $(whoami)
  fi
fi
