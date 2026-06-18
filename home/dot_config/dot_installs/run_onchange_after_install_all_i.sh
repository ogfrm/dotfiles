#!/bin/bash
set -euo pipefail
# czupdate_all2() {
#  cd ~/.config/.installs
#  chezmoi cat ~/.config/.installs/install_all_i.sh | bash -s -- -u  # to re-run this
# }

# alias czremove_all="chezmoi cat ~/.config/.installs/install_all_i.sh | bash -s -- -r"  # to re-run this

SCRIPT_DIR="$HOME/.config/.installs";
# SCRIPT_DIR="$( \cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
echo $0
echo $SCRIPT_DIR
# rm $0  # Delete me

UPDATE_ALL='' && UNINSTALL_ALL='' && SYSTEM_ALL=''
while getopts ":urs" opt; do
  [[ $opt == g ]] && UPDATE_ALL=' -g'
  [[ $opt == u ]] && UNINSTALL_ALL=' -u'
  [[ $opt == s ]] && SYSTEM_ALL=' -s'
done

APPDEP_ALL="curl unzip git wget tar jq"
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
# APPINSTALL_ALL="starship fzf"
APPINSTALL_ALL="oh-my-posh starship zoxide fzf fastfetch fresh eza fd ripgrep tmux bat"
# for name in $APPINSTALL_ALL ;do
#    echo "$SCRIPT_DIR/${name}_i.sh installation with $UPDATE_ALL $UNINSTALL_ALL $SYSTEM_ALL"
#   [ ! -f "$SCRIPT_DIR/${name}_i.sh" ] && continue
#   $SCRIPT_DIR/${name}_i.sh $UPDATE_ALL $UNINSTALL_ALL $SYSTEM_ALL
# # # {{ include "dotconfig/dot_rc/${name}_i.sh.sh" | sha256sum }}
# done
# sudo $SCRIPT_DIR/i_install -u $APPINSTALL_ALL
sudo $SCRIPT_DIR/i_install -i -g $APPINSTALL_ALL
# ./nerdfonts_i.sh install CascadiaCode FiraCode Meslo JetBrainsMono
# ./pipx_i.sh
# ./ansible_i.sh


# ./fonts.sh uninstall JetBrainsMono CascadiaCode  # default install firacode
# ACTION="${1:-install}"
# shift || true

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
