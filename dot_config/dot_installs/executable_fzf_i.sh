#!/usr/bin/env bash
set -euo pipefail

UPDATE=false
while getopts ":u" opt; do
  [[ $opt == u ]] && UPDATE=true
done

if command -v fzf >/dev/null 2>&1 && [ "$UPDATE" = false ]; then exit 0; fi

# Install dependencies
if command -v apt >/dev/null 2>&1; then sudo apt update && sudo apt install -y git curl; fi
if command -v yum >/dev/null 2>&1; then sudo yum install -y git curl; fi
if command -v pacman >/dev/null 2>&1; then sudo pacman -Sy --noconfirm git curl; fi

# Determine install dir
if command -v sudo >/dev/null 2>&1; then
  INSTALL_DIR="/usr/local/share/fzf"
  SUDO="sudo"
else
  INSTALL_DIR="$HOME/.fzf"
  SUDO=""
fi

# Clone or update
if [ ! -d "$INSTALL_DIR" ]; then
  echo "Installing fzf to $INSTALL_DIR..."
  $SUDO git clone --depth 1 https://github.com/junegunn/fzf.git "$INSTALL_DIR"
elif [ "$UPDATE" = true ]; then
  echo "Updating fzf in $INSTALL_DIR..."
  $SUDO git -C "$INSTALL_DIR" pull
fi

# Install fzf binaries
$SUDO "$INSTALL_DIR/install" --bin --no-update-rc
echo "fzf installation completed at $INSTALL_DIR."
