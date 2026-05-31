#!/usr/bin/env bash
set -euo pipefail

# https://starship.rs/config/#prompt
RUNCOMMAND="starship"
UPDATE=false UNINSTALL=false
[[ $EUID -eq 0 ]] && INSTALL_DIR="/usr/local/bin" || INSTALL_DIR="$HOME/.local/bin"
while getopts ":ug" opt; do
  [[ $opt == g ]] && UPDATE=true
  [[ $opt == u ]] && UNINSTALL=true
done
if [ "$UNINSTALL" = true ]; then
  rm -f "$HOME/.local/bin/$RUNCOMMAND"
  rm -rf "$HOME/.local/share/starship/themes"
  [[ $EUID -eq 0 ]] && rm -rf "/usr/local/share/starship/themes"
  [[ $EUID -eq 0 ]] && rm -f "/usr/local/bin/$RUNCOMMAND"
  exit 0
fi
if command -v $RUNCOMMAND >/dev/null 2>&1 && [ "$UPDATE" = false ]; then exit 0; fi
[[ $EUID -eq 0 ]] && curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir "$INSTALL_DIR" --yes
# sh -c "echo -e 'y' | $(wget https://starship.rs/install.sh -O -)"

# THEMES_DIR="$HOME/.local/share/starship/themes"
# mkdir -p "$THEMES_DIR"
# for preset in $(starship preset --list); do
#     out="$THEMES_DIR/starship_${preset}.toml"
#     # echo "Generating $preset -> $out"
#     starship preset "$preset" > "$out";
# done
