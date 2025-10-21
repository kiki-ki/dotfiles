#! /usr/bin/env sh

set -eu

if [ "$(sudo echo hi)" != hi ]; then
  echo "Cannot use sudo."
else
  # install apt packages
  sudo apt-get update && sudo apt-get install -y \
    awscli \
    bat \
    build-essential \
    curl \
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

  # shell
  if command -v zsh >/dev/null 2>&1; then
    sudo chsh -s "$(which zsh)" "$(whoami)"
  fi

  # ssd setting
  sudo mkdir /var/run/sshd
  sudo /usr/sbin/sshd

  # install other tools
  sudo env UV_INSTALL_DIR="/usr/bin" sh -c "$(curl -LsSf https://astral.sh/uv/install.sh)"
  sudo env PNPM_HOME="/usr/bin" sh -c "$(curl -LsSf https://get.pnpm.io/install.sh)"
  sudo sh -c "$(curl -sS https://starship.rs/install.sh)" -- --yes --bin-dir /usr/bin
  curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh | sudo bash -s -- --repo rossmacarthur/sheldon --to /usr/bin
  curl -L "https://github.com/eza-community/eza/releases/latest/download/eza_aarch64-unknown-linux-gnu.tar.gz" | sudo tar xz -C /usr/bin/
  sudo chmod +x /usr/bin/eza
  sudo env BINDIR="/usr/bin" sh -c "$(curl -fsLS get.chezmoi.io)"

  if command -v pnpm >/dev/null 2>&1; then
    pnpm config set --location=global minimumReleaseAge 4320 # 3days
  fi
fi
