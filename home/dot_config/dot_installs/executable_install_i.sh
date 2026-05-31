#!/usr/bin/env bash
set -euo pipefail
echo "$@"
usage() {
    echo "Usage: $0 [-p PATTERN] [-d INSTALL_DIR] -r <owner/repo> <binary>"
    echo install-release sharkdp/bat bat # Install to ~/.local/bin
    echo install-release -p x86_64-unknown-linux-gnu.tar.gz sharkdp/bat bat # Custom asset pattern
    echo install-release -d ~/bin sharkdp/bat bat # Custom install directory
    echo if run with sudo it will install system wide
    exit 1
}
# [[ -w folder ]] checks if a specific folder is writable.

INSTALL_DIR=""; REPO=""; APP_NAME=""; UNINSTALL=false; APP_FORCE=false; APP_DEB_FORCE=false; UPDATE=false;
PATTERN=""; PATTERN_ADD="-unknown-linux-musl.tar.gz"

while [[ $# -gt 0 ]]; do
    case "$1" in
        -u|--remove) UNINSTALL=true; shift 1 ;;
        -a|--app) APP_NAME="$2"; shift 2 ;;
        -g|--upgrade) UPDATE=true; shift 1 ;;
        --app-force) APP_FORCE=true; shift 1 ;;
        --deb-force) APP_DEB_FORCE=true; shift 1 ;;
        -p|--pattern) PATTERN="$2"; shift 2 ;;
        --pattern-add) PATTERN_ADD="$2"; shift 2 ;;
        -d|--dir) INSTALL_DIR="$2"; shift 2 ;;
        -r|--repo) REPO="$2"; shift 2 ;;
        -h|--help) usage ;;
        # --) shift; break ;;
        -*) echo "Unknown option: $1"; usage ;;
        *) break ;;
    esac
done

[[ $# -eq 1 ]] || usage
RUNCOMMAND="$1"
case "$(uname -m)" in
    x86_64) ARCH="x86_64" ;;
    aarch64|arm64) ARCH="aarch64" ;;
    *) ARCH="" ;;
esac

# --- Helper functions ---
real_user() {
    echo "${SUDO_USER:-$(id -un)}"
}
real_home() {
    getent passwd "$(real_user)" | cut -d: -f6 2>/dev/null || echo "$HOME"
}
find_url() {
    local pattern="$1"
    curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" |
    (command -v jq >/dev/null && jq -r ".assets[].browser_download_url|select(test(\"$pattern\"))" ||
    grep '"browser_download_url"' | grep "$pattern" | cut -d'"' -f4) | head -n1
}

app_uninstall_all() {
    echo $(real_home)
  # if command -v $RUNCOMMAND >/dev/null 2>&1; then
    if command -v apt >/dev/null 2>&1; then sudo apt remove -fy -qq "$@" || true
    elif command -v dnf >/dev/null 2>&1; then sudo dnf remove -y -q "$@"
    elif command -v yum >/dev/null 2>&1; then sudo yum remove -y "$@"
    elif command -v pacman >/dev/null 2>&1; then sudo pacman -Rns --noconfirm "$@"
    elif command -v apk >/dev/null 2>&1; then sudo apk del "$@"
    else echo "No supported package manager found."; return 1
    fi
    rm -f "/usr/local/bin/$RUNCOMMAND"
    rm -f "$(real_home)/.local/bin/$RUNCOMMAND"
  # fi
}
app_install_all() {
  if command -v apt >/dev/null 2>&1; then
    if $APP_DEB_FORCE; then
      [[ -n "$ARCH" ]] || { echo "Unsupported architecture: $(uname -m)"; return 1; }
      URL=$(find_url "-linux-${ARCH//x86_64/amd64}.deb")
      [[ -n "$URL" ]] || { echo "No release asset matching '$PATTERN'"; return 1; }
      curl -LO "$URL" && sudo dpkg -i "$(basename "$URL")" && rm "$(basename "$URL")"
      sudo apt-get install -fy     # If dependencies fail after installation:
    else
      sudo apt update && sudo apt install -y "$@";
    fi
  elif command -v dnf >/dev/null 2>&1; then sudo dnf install -y "$@";
  elif command -v yum >/dev/null 2>&1; then sudo yum install -y "$@";
  elif command -v pacman >/dev/null 2>&1; then sudo pacman -Sy --noconfirm "$@";
  elif command -v apk >/dev/null 2>&1; then sudo apk add "$@";
  else echo "No supported package manager found."; return 1
  fi
}
app_upgrade_all() {
  if command -v apt >/dev/null 2>&1; then apt-get update -qq && apt-get upgrade -y -qq >/dev/null;
  elif command -v dnf >/dev/null 2>&1; then sudo dnf upgrade -y -q;
  elif command -v yum >/dev/null 2>&1; then sudo yum upgrade -y -q;
  elif command -v pacman >/dev/null 2>&1; then sudo pacman -Syu --noconfirm;
  elif command -v apk >/dev/null 2>&1; then sudo apk upgrade;
  else echo "No supported package manager found."; return 1
  fi
}

git_install() {
  [[ -n "$ARCH" ]] || { echo "Unsupported architecture: $(uname -m)"; return 1; }
  TMPDIR=$(mktemp -d); trap 'rm -rf "$TMPDIR"' EXIT

  # Determine libc / Alpine
  # Determine libc preference
  if grep -qi alpine /etc/os-release 2>/dev/null || (command -v ldd >/dev/null && ldd --version 2>&1 | grep -qi musl); then
      LIBC_PREF="musl gnu"
  else
      LIBC_PREF="gnu musl"
  fi

  # Try each libc in order
  for LIBC in $LIBC_PREF; do
    PATTERN="${ARCH}-unknown-linux-${LIBC}.tar.gz"
    # echo $PATTERN
    URL=$(find_url "$PATTERN")
    # URL=$(
    #   curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" |
    #   (command -v jq >/dev/null && jq -r ".assets[].browser_download_url|select(test(\"$PATTERN\"))" ||
    #   grep '"browser_download_url"' | grep "$PATTERN" | cut -d'"' -f4) | head -n1
    #   )
    # echo ---$URL---
    [[ -n "$URL" ]] && break
  done
  [[ -n "$URL" ]] || URL=$(find_url "-linux-${ARCH//x86_64/amd64}.tar.gz")
  [[ -n "$URL" ]] || { echo "No release asset matching '$PATTERN'"; return 1; }
    echo ---$URL---

  ARCHIVE="$TMPDIR/archive.tar.gz"
  curl -fsSL "$URL" -o "$ARCHIVE"
  tar -xzf "$ARCHIVE" -C "$TMPDIR"

  BIN=$(find "$TMPDIR" -type f -name "$RUNCOMMAND" | head -n1)
  [[ -f "$BIN" ]] || BIN=$(find "$TMPDIR" -type f -perm -111 ! -name '*.so*' ! -name '*.dll' ! -name '*.dylib' | head -n1)
  [[ -f "$BIN" ]] || { echo "No executable found in archive"; return 1; }

  mkdir -p "$INSTALL_DIR"
  install -m 755 "$BIN" "$INSTALL_DIR/$RUNCOMMAND"

  # "$INSTALL_DIR/$RUNCOMMAND" --version
  echo "Installed $RUNCOMMAND -> $INSTALL_DIR/$RUNCOMMAND"
  # chmod 755 "$INSTALL_BIN"
	# [[ -n "$SUDO" ]] && sudo chown root:root "$INSTALL_BIN"
  # $SUDO mv "$INSTALL_BIN" "$INSTALL_DIR/$RUNCOMMAND"

}

$UNINSTALL && { app_uninstall_all "$APP_NAME"; exit 0; }

# if command -v $RUNCOMMAND >/dev/null 2>&1 && [ "$UPDATE" = false ]; then exit 0; fi
if [[ -z "$INSTALL_DIR" ]]; then
    [[ $EUID -eq 0 ]] && INSTALL_DIR="/usr/local/bin" || INSTALL_DIR="$HOME/.local/bin"
fi
  # INSTALL_DIR="/usr/local/bin"
  # [[ -w "$INSTALL_DIR" ]] || { INSTALL_DIR="$HOME/.local/bin"; mkdir -p "$INSTALL_DIR"; }

! $APP_FORCE && [[ -n "$REPO" ]] && git_install || true
##  $APP_FORCE && [[ -n "$REPO" ]] && git_install "$RUNCOMMAND" "$REPO" "$INSTALL_DIR" "$PATTERN"
($APP_FORCE || [[ -z "$REPO" ]]) && [[ $EUID -eq 0 ]] && [[ -n "$APP_NAME" ]] && app_install_all $APP_NAME || true

# cmd_path=$(command -v my_command)
# # Ensure it exists AND starts with "/" (ignoring keywords/builtins/aliases)
# if [ -n "$cmd_path" ] && [ "${cmd_path#"${cmd_path%%[!/]*}"}" = "/" ]; then
#     echo "Actual executable file exists."
# fi