#!/usr/bin/env bash
set -euo pipefail
# CascadiaCode FiraCode Meslo JetBrainsMono

URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

DIR="$HOME/.local/share/fonts"
mkdir -p "$DIR"
CHANGED=0

# ./fonts.sh uninstall JetBrainsMono CascadiaCode  # default install firacode
ACTION="${1:-install}"
shift || true
[[ $# -eq 0 ]] && set -- FiraCode

# ./fonts.sh -u JetBrainsMono CascadiaCode  # default install firacode
# ACTION=install
# while getopts "iug" o; do   # -i -u -g
#   case "$o" in
#     i) ACTION=install ;;
#     u) ACTION=uninstall ;;
#     g) ACTION=upgrade ;;
#   esac
# done
# shift $((OPTIND - 1))
# [[ $# -eq 0 ]] && set -- FiraCode

app_name() {
  case "$1" in
    CascadiaCode) echo "CaskaydiaCove" ;;
    *) echo "$1" ;;
  esac
}

app_installed() {
  \find "$DIR" \( -iname "*$(app_name $1)*.ttf" -o -iname "*$(app_name $1)*.otf" \) | \grep -iq .
  # fc-list | \grep -iq "$(app_name $1)" && { echo "$1 already installed"; return; }
}

app_install() {
  app_installed "$1" && { echo "$1 already installed"; return; }
  \curl -fsSL "$URL/$1.zip" -o "$TMP/$1.zip"
  \unzip -oq "$TMP/$1.zip" -d "$TMP/$1"
  \find "$TMP/$1" \( -iname "*.ttf" -o -iname "*.otf" \) -exec cp {} "$DIR" \;
}

app_uninstall() {
  app_installed "$1" || { echo "$1 is not installed"; return; }
  \find "$HOME/.local/share/fonts" /usr/local/share/fonts /usr/share/fonts \
    \( -iname "*$(app_name "$1")*.ttf" -o -iname "*$(app_name "$1")*.otf" \) \
    2>/dev/null -delete
  CHANGED=1
}

for f in "$@"; do
  echo "$ACTION $f..."
  case "$ACTION" in
    install) app_install "$f" ;;
    uninstall) app_uninstall "$f" ;;
    upgrade) app_uninstall "$f"; app_install "$f" ;;
  esac
done
[[ "$CHANGED" -eq 1 ]] && fc-cache -fv &> /dev/null
echo
