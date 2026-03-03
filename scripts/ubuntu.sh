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

  # awscli
  if ! command -v aws >/dev/null 2>&1; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-$ARCH.zip" -o "awscliv2.zip"
    unzip -q awscliv2.zip
    ./aws/install --update --bin-dir "$LOCAL_BIN" --install-dir "$HOME/.local/aws-cli"
    rm -rf awscliv2.zip aws
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
