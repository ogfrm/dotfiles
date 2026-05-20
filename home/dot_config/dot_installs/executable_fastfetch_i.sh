#!/bin/bash
set -euo pipefail

if ! command -v fastfetch &> /dev/null; then
  # deb=$(curl -s https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest \
  # | grep browser_download_url \
  # | grep 'fastfetch-linux-amd64\.tar.gz"' \
  # | cut -d '"' -f 4)
  # | grep 'fastfetch-linux-amd64\.deb"' \
  # curl -LO "$deb" && sudo dpkg -i "$(basename "$deb")" && rm $(basename "$deb")
  # If dependencies fail after installation:
  # sudo apt-get install -f

  BIN_DIR="${HOME}/.local/bin"
  TMP_DIR="$(mktemp -d)"

  cleanup() {
    rm -rf "$TMP_DIR"
  }
  trap cleanup EXIT

  mkdir -p "$BIN_DIR"

  ARCH="$(uname -m)"
  case "$ARCH" in
    x86_64)   FASTFETCH_ARCH="amd64" ;;
    aarch64|arm64) FASTFETCH_ARCH="aarch64" ;;
    *)
      echo "Unsupported architecture: $ARCH"
      exit 1
      ;;
  esac

  OS="$(uname -s | tr '[:upper:]' '[:lower:]')"

  RELEASE_JSON="$(curl -fsSL https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest)"

  ASSET_URL="$(printf '%s\n' "$RELEASE_JSON" \
    | grep -oE "https://[^ ]*fastfetch-${OS}-${FASTFETCH_ARCH}\.tar\.gz" \
    | head -n1)"

  if [ -z "$ASSET_URL" ]; then
    echo "Could not find matching fastfetch release asset"
    exit 1
  fi

  curl -fsSL "$ASSET_URL" -o "$TMP_DIR/fastfetch.tar.gz"
  tar -xzf "$TMP_DIR/fastfetch.tar.gz" -C "$TMP_DIR"
  find "$TMP_DIR" -type f -name fastfetch -exec install -m 0755 {} "$BIN_DIR/fastfetch" \;

  echo "Installed fastfetch to $BIN_DIR/fastfetch"
  "$BIN_DIR/fastfetch" --version


fi