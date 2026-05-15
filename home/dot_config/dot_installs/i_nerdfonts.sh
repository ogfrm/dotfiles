#!/usr/bin/env bash

set -e

FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

declare -A fonts=(
  [JetBrainsMono]="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
  [CascadiaCode]="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip"
  [FiraCode]="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
)

TMP=$(mktemp -d)

for font in "${!fonts[@]}"; do
  echo "Installing $font..."
  curl -L "${fonts[$font]}" -o "$TMP/$font.zip"
  unzip -o "$TMP/$font.zip" -d "$TMP/$font"
  find "$TMP/$font" -iname "*.ttf" -o -iname "*.otf" \
    -exec cp {} "$FONT_DIR" \;
done

fc-cache -fv
