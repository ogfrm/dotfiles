#!/bin/bash
set -euo pipefail
if ! command -v oh-my-posh &> /dev/null; then
  if ! command -v unzip &> /dev/null; then
    if command -v apt >/dev/null 2>&1; then sudo apt update && sudo apt install -y unzip; fi
    if command -v yum >/dev/null 2>&1; then sudo yum install -y unzip; fi
    if command -v pacman >/dev/null 2>&1; then sudo pacman -Sy --noconfirm unzip; fi
  fi

  curl -s https://ohmyposh.dev/install.sh | bash -s
  # oh-my-posh font install
  # oh-my-posh font install meslo
  oh-my-posh font install FiraCode

  # THEMES_DIR="$HOME/.config/oh-my-posh"
  THEMES_DIR="$HOME/.local/shares/oh-my-posh/themes"
  mkdir -p "$THEMES_DIR"
  curl -s https://api.github.com/repos/JanDeDobbeleer/oh-my-posh/contents/themes \
  | jq -r '.[].name' \
  | while IFS= read -r theme; do
      # echo "Downloading $theme..."
      curl -s -o "$THEMES_DIR/$theme" "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/$theme"
  done
fi
