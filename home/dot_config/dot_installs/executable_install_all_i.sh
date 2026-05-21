#!/bin/bash
set -euo pipefail

echo 0
UPDATE_ALL='' && UNINSTALL_ALL='' && SYSTEM_ALL=''
while getopts ":urs" opt; do
  [[ $opt == u ]] && UPDATE_ALL=' -u'
  [[ $opt == r ]] && UNINSTALL_ALL=' -r'
  [[ $opt == s ]] && SYSTEM_ALL=' -s'
done
echo 1
APPDEP_ALL="curl unzip git wget tar"
for name in $APPDEP_ALL ;do
  if command -v $name >/dev/null 2>&1; then continue; fi
  if command -v apt >/dev/null 2>&1; then sudo apt update && sudo apt install -y $APPDEP_ALL;
  elif command -v yum >/dev/null 2>&1; then sudo yum install -y $APPDEP_ALL;
  elif command -v pacman >/dev/null 2>&1; then sudo pacman -Sy --noconfirm $APPDEP_ALL;
  elif command -v dnf >/dev/null 2>&1; then sudo dnf install -y $APPDEP_ALL;
  fi
  break
done
echo 2
APPINSTALL_ALL="ohmyposh starship zoxide fzf eza fastfetch fresh ripgrep"
for name in $APPDEP_ALL ;do
  echo ./${name}_i.sh $UPDATE_ALL $UNINSTALL_ALL $SYSTEM_ALL
  [ ! -f "${name}_i.sh" ] && continue
  echo ./${name}_i.sh $UPDATE_ALL $UNINSTALL_ALL $SYSTEM_ALL
# # {{ include "dotconfig/dot_rc/${name}_i.sh.sh" | sha256sum }}
done
echo 3

# ./nerdfonts_i.sh install CascadiaCode FiraCode Meslo JetBrainsMono
# ./pipx_i.sh
# ./ansible_i.sh
