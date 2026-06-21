#!/bin/bash
set -euo pipefail
RUNCOMMAND="oh-my-posh"
INSTALL_DIR="$HOME/.local/bin/oh-my-posh"

UPDATE=false && UNINSTALL=false
while getopts ":gu" opt; do
  [[ $opt == g ]] && UPDATE=true
  [[ $opt == u ]] && UNINSTALL=true
done
SCRIPT_DIR="$( \cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
"$SCRIPT_DIR/install_i.sh" "$@" --repo "JanDeDobbeleer/oh-my-posh" oh-my-posh
real_user() {
    echo "${SUDO_USER:-$(id -un)}"
}
real_home() {
    getent passwd "$(real_user)" | cut -d: -f6 2>/dev/null || echo "$HOME"
}

if [ "$UNINSTALL" = true ]; then # /usr/bin
  echo $(real_home)
  rm -rf "$(real_home)/.cache/oh-my-posh"
  exit 0
fi
# if command -v "$RUNCOMMAND" >/dev/null 2>&1 && [ "$UPDATE" = false ]; then exit 0; fi

$(command -v oh-my-posh) font install FiraCode || true # meslo

themes_dir="$HOME/.cache/oh-my-posh/themes"
mkdir -p "$themes_dir" > /dev/null 2>&1
zip_file="${cache_dir}/themes.zip"
url="https://cdn.ohmyposh.dev/releases/latest/themes.zip"
http_response=$(curl -s -f -L $url -o $zip_file -w "%{http_code}")
if [ $http_response = "200" ] && [ -f $zip_file ]; then
  unzip -o -q $zip_file -d $themes_dir
  chmod a+rwX ${themes_dir}/*.omp.*
  rm $zip_file
fi

# # oh-my-posh init zsh --config /home/ozgur/.cache/oh-my-posh/themes/slimfat.omp.json