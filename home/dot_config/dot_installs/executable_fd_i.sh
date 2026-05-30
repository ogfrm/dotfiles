#!/bin/bash
set -euo pipefail
RUNCOMMAND="fd"
REPO="sharkdp/fd"
UPDATE=false && UNINSTALL=false
INSTALL_DIR=""
# INSTALL_DIR="/usr/local/bin"
# [[ -w folder ]] checks if a specific folder is writable.
# [[ -w "$INSTALL_DIR" ]] || { INSTALL_DIR="$HOME/.local/bin"; mkdir -p "$INSTALL_DIR"; }

while getopts ":urs" opt; do
  [[ $opt == u ]] && UPDATE=true
  [[ $opt == r ]] && UNINSTALL=true
done

if [ "$UNINSTALL" = true ]; then # /usr/bin
  if command -v fd >/dev/null 2>&1; then
    sudo apt remove fd-find -y || true
    echo "fd-find uninstallation completed"
    rm -f "/usr/local/bin/fd"
    rm -f "$HOME/.local/bin/fd"
  fi
  exit 0
fi
if command -v $RUNCOMMAND >/dev/null 2>&1 && [ "$UPDATE" = false ]; then exit 0; fi

if false && [[ $EUID -eq 0 ]] && command -v apt >/dev/null 2>&1; then
  sudo apt install fd-find -y || true
else
  if [[ -z "$INSTALL_DIR" ]]; then
    [[ $EUID -eq 0 ]] && INSTALL_DIR="/usr/local/bin" || INSTALL_DIR="$HOME/.local/bin" # if run with sudo
  fi
  echo $INSTALL_DIR
  PATTERN=""
  ARCH="$(uname -m)"
  case "$ARCH" in
      x86_64) PATTERN="x86_64-unknown-linux-musl.tar.gz" ;;
      aarch64|arm64) PATTERN="aarch64-unknown-linux-musl.tar.gz" ;;
      *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
  esac

  DOWNLOAD_URL=$( curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" |
    (command -v jq >/dev/null && jq -r ".assets[].browser_download_url|select(test(\"$PATTERN\"))" ||
    grep '"browser_download_url"' | grep "$PATTERN" | cut -d'"' -f4) | head -n1 )

  [[ -n "$DOWNLOAD_URL" ]] || { echo "No matching release found."; exit 1; }
  echo "Downloading $DOWNLOAD_URL..."
  TMPDIR=$(mktemp -d); trap 'rm -rf "$TMPDIR"' EXIT

  ARCHIVE="$TMPDIR/archive.tar.gz"
  curl -fL "$DOWNLOAD_URL" -o "$ARCHIVE"
  tar -xzf "$ARCHIVE" -C "$TMPDIR"

  INSTALL_BIN=$(find "$TMPDIR" -type f -name $RUNCOMMAND | head -n1)
  [[ -f "$INSTALL_BIN" ]] || INSTALL_BIN=$(find "$TMPDIR" -type f -perm -111 ! -name '*.so*' ! -name '*.dll' ! -name '*.dylib' | head -n1)

  [[ -f "$INSTALL_BIN" ]] || { echo "$RUNCOMMAND binary not found!"; exit 1; }

	mkdir -p "$INSTALL_DIR"
  install -m 755 "$INSTALL_BIN" "$INSTALL_DIR/$RUNCOMMAND"

  # chmod 755 "$INSTALL_BIN"
	# [[ -n "$SUDO" ]] && sudo chown root:root "$INSTALL_BIN"
  # $SUDO mv "$INSTALL_BIN" "$INSTALL_DIR/$RUNCOMMAND"
  # echo "Installed $RUNCOMMAND to $INSTALL_DIR/$RUNCOMMAND"
  # "$INSTALL_DIR/$RUNCOMMAND" --version
fi
