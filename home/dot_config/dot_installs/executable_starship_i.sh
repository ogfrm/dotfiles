#!/usr/bin/env bash
set -euo pipefail
# https://starship.rs/config/#prompt
if ! command -v starship &> /dev/null; then
    # curl -sS https://starship.rs/install.sh | sh
  # usualy /user/local/bin
  curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir "$HOME/.local/bin"  --yes
  # sh -c "echo -e 'y' | $(wget https://starship.rs/install.sh -O -)"

  CONFIG_DIR="$HOME/.config/starship"
  mkdir -p "$CONFIG_DIR"

  for preset in $(starship preset --list); do
      out="$CONFIG_DIR/starship_${preset}.toml"
      echo "Generating $preset -> $out"
      starship preset "$preset" > "$out";
  done
fi