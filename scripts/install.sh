#!/bin/bash
set -eu

OS="$(uname -s)"

case "$OS" in
  Darwin)
    echo "macOS detected. Running setup script..."
    sh ./scripts/macos.sh
    ;;
  Linux)
    echo "linux detected. Running setup script..."
    sh ./scripts/ubuntu.sh
    ;;
  *)
    echo "Error: Unsupported OS: $OS"
    exit 1
    ;;
esac
