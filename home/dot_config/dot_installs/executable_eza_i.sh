#!/usr/bin/env bash
set -euo pipefail

RUNCOMMAND="eza"

UPDATE=false && UNINSTALL=false && SUDO=""
INSTALL_DIR="$HOME/.local/bin"
while getopts ":urs" opt; do
  [[ $opt == u ]] && UPDATE=true
  [[ $opt == r ]] && UNINSTALL=true
  [[ $opt == s ]] && INSTALL_DIR="/user/local/bin" && SUDO="sudo"
done
if [ "$UNINSTALL" = true ]; then
  [ -f "$HOME/.local/bin/eza" ] && rm $HOME/.local/bin/eza
  [ - f "/usr/local/bin/eza" ]sudo apt remove eza -y
  echo "$RUNCOMMAND uninstallation completed at $INSTALL_DIR"
  exit 0
fi
if command -v $RUNCOMMAND >/dev/null 2>&1 && [ "$UPDATE" = false ]; then exit 0; fi
if [[ -z $SUDO ]]; then
  wget -c https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz -O - | tar xz
  # chown $USER:$USER eza
  chmod +x eza
  # sudo chown root:root eza
  # sudo mv eza /usr/local/bin/eza
  mv eza "$INSTALL_DIR"
else
  sudo apt update
  sudo apt install -y gpg
  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
  sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
  sudo apt update
  sudo apt install -y eza
fi
