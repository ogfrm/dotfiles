#!/usr/bin/env bash
set -euo pipefail

UPDATE=false && UNINSTALL=false && SUDO=""
INSTALL_DIR="$HOME/.local/share/fzf"
while getopts ":urs" opt; do
  [[ $opt == u ]] && UPDATE=true
  [[ $opt == r ]] && UNINSTALL=true
  [[ $opt == s ]] && INSTALL_DIR="/usr/local/share/fzf" && SUDO="sudo"
done
if [ "$UNINSTALL" = true ]; then
  $SUDO \rm -rf -- $INSTALL_DIR
  echo "fzf uninstallation completed at $INSTALL_DIR."
  exit 0
fi
if command -v fzf >/dev/null 2>&1 && [ "$UPDATE" = false ]; then exit 0; fi
if ! command -v git >/dev/null 2>&1; then
  # Install dependencies
  if command -v apt >/dev/null 2>&1; then sudo apt update && sudo apt install -y git;
  elif command -v yum >/dev/null 2>&1; then sudo yum install -y git;
  elif command -v pacman >/dev/null 2>&1; then sudo pacman -Sy --noconfirm git;
  elif command -v dnf >/dev/null 2>&1; then sudo dnf install -y git
  fi
fi
# Clone or update
if [ ! -d "$INSTALL_DIR" ]; then
  echo "Installing fzf to $INSTALL_DIR..."
  $SUDO git clone --depth 1 https://github.com/junegunn/fzf.git "$INSTALL_DIR"
  $SUDO "$INSTALL_DIR/install" --bin --no-update-rc
elif [ "$UPDATE" = true ]; then
  echo "Updating fzf in $INSTALL_DIR..."
  $SUDO git -C "$INSTALL_DIR" pull
fi
echo "fzf installation completed at $INSTALL_DIR."
