#!/usr/bin/env bash
set -euo pipefail

# https://starship.rs/config/#prompt
RUNCOMMAND="starship"
THEMES_DIR="$HOME/.local/shares/starship/themes"

UPDATE=false && UNINSTALL=false && SUDO=""
INSTALL_DIR="--bin-dir $HOME/.local/bin"
while getopts ":urs" opt; do
  [[ $opt == u ]] && UPDATE=true
  [[ $opt == r ]] && UNINSTALL=true
  [[ $opt == s ]] && INSTALL_DIR="/user/local/bin" && SUDO="sudo"
done
if [ "$UNINSTALL" = true ]; then
  [ -f "$INSTALL_DIR" ] && rm $INSTALL_DIR
  [ -d "$THEMES_DIR" ] && rm -rf $THEMES_DIR
  echo "$RUNCOMMAND uninstallation completed at $INSTALL_DIR."
  exit 0
fi
if command -v $RUNCOMMAND >/dev/null 2>&1 && [ "$UPDATE" = false ]; then exit 0; fi
if [[ -z $SUDO ]]; then
  curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir "$HOME/.local/bin"  --yes
else
  curl -sS https://starship.rs/install.sh | sh
# sh -c "echo -e 'y' | $(wget https://starship.rs/install.sh -O -)"
fi

mkdir -p "$THEMES_DIR"
for preset in $(starship preset --list); do
    out="$THEMES_DIR/starship_${preset}.toml"
    echo "Generating $preset -> $out"
    starship preset "$preset" > "$out";
done
