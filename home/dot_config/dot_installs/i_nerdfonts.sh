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

# VS Code settings (merge/update existing settings.json)
VSCODE="$HOME/.config/Code/User/settings.json"
mkdir -p "$(dirname "$VSCODE")"

# create file if missing
[ -f "$VSCODE" ] || echo "{}" > "$VSCODE"

TMP_JSON=$(mktemp)

python3 <<EOF
import json

path = "$VSCODE"

with open(path, "r") as f:
    data = json.load(f)

data["editor.fontFamily"] = "JetBrainsMono Nerd Font"
data["terminal.integrated.fontFamily"] = "JetBrainsMono Nerd Font"

with open("$TMP_JSON", "w") as f:
    json.dump(data, f, indent=2)
EOF

mv "$TMP_JSON" "$VSCODE"


# WSL Windows Terminal hint
if grep -qi microsoft /proc/version; then
  echo "WSL detected."
  echo "Set Windows Terminal font to: JetBrainsMono Nerd Font"
fi

echo "Done. Restart VS Code / terminal."