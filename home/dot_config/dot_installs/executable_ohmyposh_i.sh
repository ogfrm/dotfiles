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
  # oh-my-posh font install
# "$INSTALL_DIR" font install FiraCode  # meslo
mkdir -p "$THEMES_DIR"
curl -s https://api.github.com/repos/JanDeDobbeleer/oh-my-posh/contents/themes \
| jq -r '.[].name' \
| while IFS= read -r theme; do
    # echo "Downloading $theme..."
    curl -s -o "$THEMES_DIR/$theme" "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/$theme"
done
