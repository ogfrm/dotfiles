#!/usr/bin/env bash
# https://github.com/eza-community/eza
set -euo pipefail

RUNCOMMAND="eza"
UPDATE=false UNINSTALL=false
while getopts ":urs" opt; do
	case "$opt" in
	g) UPDATE=true ;;
	u) UNINSTALL=true ;;
	esac
done
# [[ $EUID -eq 0 ]] && INSTALL_DIR="/usr/local/bin" || INSTALL_DIR="$HOME/.local/bin"

SCRIPT_DIR="$( \cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
"$SCRIPT_DIR/ins_git_latest_i.sh" "$@" --repo "eza-community/eza" --app eza eza
# if [[ -n "$SUDO" ]] && command -v apt >/dev/null 2>&1; then
#     sudo apt update
#     sudo apt install -y gpg
#     sudo mkdir -p /etc/apt/keyrings
#     wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
#     echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
#     sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
#     sudo apt update
#     sudo apt install -y eza
# else
  # wget -qO- "https://github.com/eza-community/eza/releases/latest/download/eza_${TARGET}.tar.gz" | tar xz
if $UNINSTALL; then
  echo $UNINSTALL
  # rm -f "$HOME/.local/bin/eza"
  rm -f "$HOME/.local/share/bash-completion/completions/eza" "$HOME/.local/share/zsh/site-functions/_eza"
  if [[ $EUID -eq 0 ]]; then
    # rm -f "/usr/local/bin/eza"
    rm -f "/usr/local/share/bash-completion/completions/eza" "/usr/local/share/zsh/site-functions/_eza"
    # command -v apt >/dev/null 2>&1 && sudo apt remove -y eza || true
    sudo rm -f /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo rm -f /usr/share/bash-completion/completions/eza /usr/share/zsh/site-functions/_eza /usr/local/bin/eza
  fi
else

  # [[ $EUID -eq 0 ]] && BC="/usr/local/share" || BC="$HOME/.local/share"
  [[ $EUID -eq 0 ]] && BC="/usr/share" || BC="$HOME/.local/share"
  echo $BC
  mkdir -p "$BC/bash-completion/completions" "$BC/zsh/site-functions"
  wget -qO "$BC/bash-completion/completions/eza" https://github.com/eza-community/eza/raw/main/completions/bash/eza
  wget -qO "$BC/zsh/site-functions/_eza" https://github.com/eza-community/eza/raw/main/completions/zsh/_eza
fi
