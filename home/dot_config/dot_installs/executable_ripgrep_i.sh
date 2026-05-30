#!/bin/bash
set -euo pipefail
# /usr/bin/rg
RUNCOMMAND="rg"
UPDATE=false && UNINSTALL=false
while getopts ":ur" opt; do
  [[ $opt == u ]] && UPDATE=true
  [[ $opt == r ]] && UNINSTALL=true
done
if [ "$UNINSTALL" = true ]; then # /usr/bin
  if command -v $RUNCOMMAND >/dev/null 2>&1; then
    sudo apt remove ripgrep -y || true
    echo "ripgrep uninstallation completed"
  fi
  exit 0
fi
if command -v $RUNCOMMAND >/dev/null 2>&1 && [ "$UPDATE" = false ]; then exit 0; fi
if [[ -n "$SUDO" ]] && command -v apt >/dev/null 2>&1; then
  deb=$(curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest \
  | grep browser_download_url \
  | grep '\.deb"' \
  | cut -d '"' -f 4)
  curl -LO "$deb" && sudo dpkg -i "$(basename "$deb")" && rm $(basename "$deb")
  # If dependencies fail after installation:
  sudo apt-get install -f
else
  RUNCOMMAND="rg"
  REPO="BurntSushi/ripgrep"
  ARCH="$(uname -m)"
  PATTERN=""
  case "$ARCH" in
      x86_64) PATTERN="x86_64-unknown-linux-musl.tar.gz" ;;
      aarch64|arm64) PATTERN="aarch64-unknown-linux-musl.tar.gz" ;;
      *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
  esac

  DOWNLOAD_URL=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" \
      | grep '"browser_download_url"' | grep "$PATTERN" | cut -d '"' -f 4 | head -n1)
  [[ -n "$DOWNLOAD_URL" ]] || { echo "No matching release found."; exit 1; }
  echo "Downloading $DOWNLOAD_URL..."
  TMPDIR=$(mktemp -d)
  trap 'rm -rf "$TMPDIR"' EXIT
  ARCHIVE="$TMPDIR/$RUNCOMMAND.tar.gz"

  curl -fL "$DOWNLOAD_URL" -o "$ARCHIVE"
  tar -xzf "$ARCHIVE" -C "$TMPDIR"

  INSTALL_BIN=$(find "$TMPDIR" -type f -name $RUNCOMMAND | head -n1)
  [[ -f "$INSTALL_BIN" ]] || { echo "$RUNCOMMAND binary not found!"; exit 1; }

  # [[ -w folder ]] checks if a specific folder is writable.
  INSTALL_DIR="/usr/local/bin"
  [[ -w "$INSTALL_DIR" ]] || { INSTALL_DIR="$HOME/.local/bin"; mkdir -p "$INSTALL_DIR"; }

	$SUDO mkdir -p "$INSTALL_DIR"
  chmod 755 "$INSTALL_BIN"
	[[ -n "$SUDO" ]] && sudo chown root:root "$INSTALL_BIN"
  mv "$INSTALL_BIN" "$INSTALL_DIR/$RUNCOMMAND"
  # echo "Installed $RUNCOMMAND to $INSTALL_DIR/$RUNCOMMAND"
  # "$INSTALL_DIR/$RUNCOMMAND" --version
fi