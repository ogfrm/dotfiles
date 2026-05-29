#!/bin/bash
set -euo pipefail
RUNCOMMAND="oh-my-posh"
INSTALL_DIR="$HOME/.local/bin/oh-my-posh"
THEMES_DIR="$HOME/.local/share/oh-my-posh/themes"

UPDATE=false && UNINSTALL=false
while getopts ":urs" opt; do
  [[ $opt == u ]] && UPDATE=true
  [[ $opt == r ]] && UNINSTALL=true
done
if [ "$UNINSTALL" = true ]; then # /usr/bin
  rm-f $INSTALL_DIR
  rm -rf $THEMES_DIR
  echo "$RUNCOMMAND uninstallation completed"
  exit 0
fi
if command -v "$RUNCOMMAND" >/dev/null 2>&1 && [ "$UPDATE" = false ]; then exit 0; fi

curl -s https://ohmyposh.dev/install.sh | bash -s || true
# /.cache/oh-my-posh/themes
  # oh-my-posh font install
"$INSTALL_DIR" font install FiraCode || true # meslo
