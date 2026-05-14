#!/bin/bash

set -euo pipefail

curl -s https://ohmyposh.dev/install.sh | bash -s
# oh-my-posh font install
# oh-my-posh font install meslo
oh-my-posh font install FiraCode

REPO_URL="https://github.com/JanDeDobbeleer/oh-my-posh.git"
TARGET_DIR="$HOME/.config/ohmyposh"

echo "Creating target directory..."
mkdir -p "$TARGET_DIR"

TMP_DIR="$(mktemp -d)"

echo "Cloning oh-my-posh repository..."
git clone --depth=1 "$REPO_URL" "$TMP_DIR"

echo "Copying themes folder..."
cp -r "$TMP_DIR/themes"/* "$TARGET_DIR/"

echo "Cleaning up..."
rm -rf "$TMP_DIR"

echo "Themes downloaded to: $TARGET_DIR"