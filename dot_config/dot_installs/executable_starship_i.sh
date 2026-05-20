#!/usr/bin/env bash

# https://starship.rs/config/#prompt

set -euo pipefail

	# curl -sS https://starship.rs/install.sh | sh
curl -sS https://starship.rs/install.sh | sh -- sh -s -- --yes
# sh -c "echo -e 'y' | $(wget https://starship.rs/install.sh -O -)"

CONFIG_DIR="$HOME/.config/starship"
mkdir -p "$CONFIG_DIR"

for preset in $(starship preset --list); do
    out="$CONFIG_DIR/starship_${preset}.toml"
    echo "Generating $preset -> $out"
    starship preset "$preset" > "$out";
done