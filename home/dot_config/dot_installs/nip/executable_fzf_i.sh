#!/usr/bin/env bash
set -euo pipefail

RUNCOMMAND="fzf"
UPDATE=false && UNINSTALL=false && SUDO=""
INSTALL_DIR="$HOME/.local/share/fzf"
while getopts ":urs" opt; do
  [[ $opt == u ]] && UPDATE=true
  [[ $opt == r ]] && UNINSTALL=true
  [[ $opt == s ]] && INSTALL_DIR="/usr/local/share/fzf" && SUDO="sudo"
done
if [ "$UNINSTALL" = true ]; then
  [ -d "$INSTALL_DIR" ] && $SUDO \rm -rf -- $INSTALL_DIR
  echo "$RUNCOMMAND uninstallation completed at $INSTALL_DIR."
  exit 0
fi
if command -v "$RUNCOMMAND" >/dev/null 2>&1 && [ "$UPDATE" = false ]; then exit 0; fi

if [ ! -d "$INSTALL_DIR" ]; then
  echo "Installing $RUNCOMMAND to $INSTALL_DIR..."
  $SUDO git clone --depth 1 https://github.com/junegunn/fzf.git "$INSTALL_DIR"
elif [ "$UPDATE" = true ]; then
  echo "Updating $RUNCOMMAND in $INSTALL_DIR..."
  $SUDO git -C "$INSTALL_DIR" pull
fi
$SUDO "$INSTALL_DIR/install" --bin --no-update-rc
echo "$RUNCOMMAND installation completed at $INSTALL_DIR."
