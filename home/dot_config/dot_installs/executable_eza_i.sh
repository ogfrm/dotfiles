#!/usr/bin/env bash
# https://github.com/eza-community/eza
set -euo pipefail

RUNCOMMAND="eza"
UPDATE=false UNINSTALL=false SUDO="" INSTALL_DIR="$HOME/.local"
while getopts ":urs" opt; do
	case "$opt" in
	u) UPDATE=true ;;
	r) UNINSTALL=true ;;
	s) INSTALL_DIR="/usr/local"; SUDO="sudo" ;;
	esac
done

if $UNINSTALL; then
  rm -f "$HOME/.local/bin/eza" "$HOME/.local/share/bash-completion/completions/eza" "$HOME/.local/share/zsh/site-functions/_eza"
  sudo rm -f /usr/share/bash-completion/completions/eza /usr/share/zsh/site-functions/_eza /usr/local/bin/eza
  command -v apt >/dev/null 2>&1 && sudo apt remove -y eza || true
  sudo rm -f /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
  echo "$RUNCOMMAND uninstallation completed at $INSTALL_DIR"
  exit 0
fi
command -v "$RUNCOMMAND" >/dev/null 2>&1 && ! $UPDATE && exit 0

if [[ -n "$SUDO" ]] && command -v apt >/dev/null 2>&1; then
    sudo apt update
    sudo apt install -y gpg
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza
else
  INSTALL_DIR="$HOME/.local"
  ARCH="$(uname -m)"
  case "$ARCH" in
    x86_64) TARGET="x86_64-unknown-linux-gnu" ;;
    aarch64|arm64) TARGET="aarch64-unknown-linux-gnu" ;;
    *) echo "Unsupported architecture: $ARCH"; exit 0 ;;
  esac

  wget -qO- "https://github.com/eza-community/eza/releases/latest/download/eza_${TARGET}.tar.gz" | tar xz
  chmod +x eza
	[[ -n "$SUDO" ]] && sudo chown root:root eza
	$SUDO mkdir -p "$INSTALL_DIR/bin"
	$SUDO mv eza "$INSTALL_DIR/bin/eza"
fi

BC="$INSTALL_DIR/share"
if [[ -n "$SUDO" ]]; then BC=/usr/share; fi

$SUDO mkdir -p "$BC/bash-completion/completions" "$BC/zsh/site-functions"
$SUDO wget -qO "$BC/bash-completion/completions/eza" https://github.com/eza-community/eza/raw/main/completions/bash/eza
$SUDO wget -qO "$BC/zsh/site-functions/_eza" https://github.com/eza-community/eza/raw/main/completions/zsh/_eza

echo "eza installed to $INSTALL_DIR"
