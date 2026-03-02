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
    bat \
    build-essential \
    curl \
    file \
    git \
    gpg \
    grep \
    jq \
    less \
    lsof \
    procps \
    unzip \
    vim \
    zsh

  # charm (gum)
  if ! command -v gum >/dev/null 2>&1; then
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor --yes -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
    sudo apt-get update
    sudo apt-get install -y gum
  fi

  # gh (GitHub CLI)
  if ! command -v gh >/dev/null 2>&1; then
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor --yes -o /etc/apt/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y gh
  fi

  # mise
  if ! command -v mise >/dev/null 2>&1; then
    sudo install -dm 755 /etc/apt/keyrings
    curl -fSs https://mise.jdx.dev/gpg-key.pub | sudo tee /etc/apt/keyrings/mise-archive-keyring.asc 1>/dev/null
    echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.asc] https://mise.jdx.dev/deb stable main" | sudo tee /etc/apt/sources.list.d/mise.list
    sudo apt-get update -y
    sudo apt-get install -y mise
  fi
  eval "$(mise activate bash)"
  mise install

  # bat
  if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
    ln -s "$(command -v batcat)" "$LOCAL_BIN/bat"
  fi

  # shell
  if command -v zsh >/dev/null 2>&1; then
    if [ "$SHELL" != "$(command -v zsh)" ]; then
       sudo chsh -s "$(command -v zsh)" "$(whoami)"
    fi
  fi

  # fzf
  if [ ! -d "$HOME/.fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --all
  fi

  # awscli
  if ! command -v aws >/dev/null 2>&1; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-$ARCH.zip" -o "awscliv2.zip"
    unzip -q awscliv2.zip
    ./aws/install --update --bin-dir "$LOCAL_BIN" --install-dir "$HOME/.local/aws-cli"
    rm -rf awscliv2.zip aws
  fi

  # sheldon
  if ! command -v sheldon >/dev/null 2>&1; then
    curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh | bash -s -- --repo rossmacarthur/sheldon --to "$LOCAL_BIN"
  fi

  # uv
  if ! command -v uv >/dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR="$LOCAL_BIN" sh
  fi

  # starship
  if ! command -v starship >/dev/null 2>&1; then
    sh -c "$(curl --proto '=https' --tlsv1.2 -sS https://starship.rs/install.sh)" -- --yes --bin-dir "$LOCAL_BIN"
  fi

  # go-qo
  if ! command -v qo >/dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 -sfL https://raw.githubusercontent.com/kiki-ki/go-qo/main/install.sh | env BINDIR="$LOCAL_BIN" sh
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
