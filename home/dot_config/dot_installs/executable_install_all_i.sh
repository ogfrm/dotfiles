#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$( \cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
# rm $0  # Delete me

UPDATE_ALL='' && UNINSTALL_ALL='' && SYSTEM_ALL=''
while getopts ":urs" opt; do
  [[ $opt == u ]] && UPDATE_ALL=' -u'
  [[ $opt == r ]] && UNINSTALL_ALL=' -r'
  [[ $opt == s ]] && SYSTEM_ALL=' -s'
done

APPDEP_ALL="curl unzip git wget tar"
for name in $APPDEP_ALL ;do
  if command -v $name >/dev/null 2>&1; then continue; fi
  if command -v apt >/dev/null 2>&1; then sudo apt update && sudo apt install -y $APPDEP_ALL;
  elif command -v yum >/dev/null 2>&1; then sudo yum install -y $APPDEP_ALL;
  elif command -v pacman >/dev/null 2>&1; then sudo pacman -Sy --noconfirm $APPDEP_ALL;
  elif command -v dnf >/dev/null 2>&1; then sudo dnf install -y $APPDEP_ALL;
  elif command -v apk >/dev/null 2>&1; then sudo apk add $APPDEP_ALL;
  fi
  # break
done
APPINSTALL_ALL="ohmyposh starship zoxide eza fzf fastfetch fresh ripgrep"
for name in $APPINSTALL_ALL ;do
   echo "$name installation with $UPDATE_ALL $UNINSTALL_ALL $SYSTEM_ALL"
  [ ! -f "$SCRIPT_DIR/${name}_i.sh" ] && continue
  $SCRIPT_DIR/${name}_i.sh $UPDATE_ALL $UNINSTALL_ALL $SYSTEM_ALL
# # {{ include "dotconfig/dot_rc/${name}_i.sh.sh" | sha256sum }}
done

# ./nerdfonts_i.sh install CascadiaCode FiraCode Meslo JetBrainsMono
# ./pipx_i.sh
# ./ansible_i.sh


# ./fonts.sh uninstall JetBrainsMono CascadiaCode  # default install firacode
ACTION="${1:-install}"
shift || true

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
[[ $# -eq 0 ]] && set -- FiraCode
