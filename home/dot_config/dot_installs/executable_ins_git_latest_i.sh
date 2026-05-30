#!/usr/bin/env bash
set -euo pipefail
usage() {
    echo "Usage: $0 [-p PATTERN] [-d INSTALL_DIR] <owner/repo> <binary>"
    echo install-release sharkdp/bat bat # Install to ~/.local/bin
    echo install-release -p x86_64-unknown-linux-gnu.tar.gz sharkdp/bat bat # Custom asset pattern
    echo install-release -d ~/bin sharkdp/bat bat # Custom install directory
    echo if run with sudo it will install system wide
    exit 1
}

PATTERN=""
INSTALL_DIR=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -p|--pattern) PATTERN="$2"; shift 2 ;;
        -d|--dir) INSTALL_DIR="$2"; shift 2 ;;
        -h|--help) usage ;;
        # --) shift; break ;;
        -*) echo "Unknown option: $1"; usage ;;
        *) break ;;
    esac
done

[[ $# -eq 2 ]] || usage
REPO="$1"
RUNCOMMAND="$2"

if [[ -z "$INSTALL_DIR" ]]; then
    [[ $EUID -eq 0 ]] && INSTALL_DIR="/usr/local/bin" || INSTALL_DIR="$HOME/.local/bin"
fi

if [[ -z "$PATTERN" ]]; then
    case "$(uname -m)" in
        x86_64) PATTERN="x86_64-unknown-linux-musl.tar.gz" ;;
        aarch64|arm64) PATTERN="aarch64-unknown-linux-musl.tar.gz" ;;
        *) echo "Unsupported architecture: $(uname -m)"; exit 1 ;;
    esac
fi

TMPDIR=$(mktemp -d); trap 'rm -rf "$TMPDIR"' EXIT

URL=$(
  curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" |
  (command -v jq >/dev/null && jq -r ".assets[].browser_download_url|select(test(\"$PATTERN\"))" ||
   grep '"browser_download_url"' | grep "$PATTERN" | cut -d'"' -f4) | head -n1
  )
[[ -n "$URL" ]] || { echo "No release asset matching '$PATTERN'"; exit 1; }

ARCHIVE="$TMPDIR/archive.tar.gz"
curl -fsSL "$URL" -o "$ARCHIVE"
tar -xzf "$ARCHIVE" -C "$TMPDIR"

# Find binary
BIN=$(find "$TMPDIR" -type f -name "$RUNCOMMAND" | head -n1)
[[ -f "$BIN" ]] || BIN=$(find "$TMPDIR" -type f -perm -111 ! -name '*.so*' ! -name '*.dll' ! -name '*.dylib' | head -n1)
[[ -f "$BIN" ]] || { echo "No executable found in archive"; exit 1; }

mkdir -p "$INSTALL_DIR"
install -m 755 "$BIN" "$INSTALL_DIR/$RUNCOMMAND"

echo "Installed $RUNCOMMAND -> $INSTALL_DIR/$RUNCOMMAND"
