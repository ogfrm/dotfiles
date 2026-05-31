#!/usr/bin/env bash
set -Eeuo pipefail

usage() {
cat <<EOF
Usage:
  $0 [options] <binary>

Options:
  -r, --repo OWNER/REPO     Install from GitHub releases
  -a, --app PACKAGE         Install/remove package manager package
  -d, --dir DIR             Installation directory
  -u, --remove              Uninstall
  -g, --upgrade             Upgrade package
  --app-force               Prefer package manager over GitHub
  --deb-force               Install matching .deb release asset
  -p, --pattern PATTERN     Custom release asset pattern
  -h, --help                Show help

Examples:

  $0 -r sharkdp/bat bat
  $0 -r sharkdp/bat -d ~/bin bat
  $0 -a ripgrep rg
  $0 -u -a ripgrep rg

EOF
exit 1
}

########################################
# defaults
########################################

INSTALL_DIR=""
REPO=""
APP_NAME=""
RUNCOMMAND=""

UNINSTALL=false
UPGRADE=false
APP_FORCE=false
DEB_FORCE=false

PATTERN=""

########################################
# helpers
########################################

die() {
    echo "Error: $*" >&2
    exit 1
}

real_user() {
    echo "${SUDO_USER:-$(id -un)}"
}

real_home() {
    getent passwd "$(real_user)" 2>/dev/null | cut -d: -f6 || echo "$HOME"
}

detect_arch() {
    case "$(uname -m)" in
        x86_64) echo x86_64 ;;
        aarch64|arm64) echo aarch64 ;;
        armv7l) echo armv7 ;;
        i686|i386) echo i386 ;;
        *)
            return 1
            ;;
    esac
}

detect_libc() {
    if grep -qi alpine /etc/os-release 2>/dev/null ||
       (command -v ldd >/dev/null &&
        ldd --version 2>&1 | grep -qi musl); then
        echo musl
    else
        echo gnu
    fi
}

github_api() {
    curl -fsSL \
      "https://api.github.com/repos/${REPO}/releases/latest"
}

find_release_url() {
    local pattern="$1"

    github_api |
    jq -r \
       --arg p "$pattern" \
       '.assets[].browser_download_url
        | select(test($p))' |
    head -n1
}

########################################
# package manager
########################################

pkg_install() {

    if command -v apt >/dev/null; then
        sudo apt update
        sudo apt install -y "$@"

    elif command -v dnf >/dev/null; then
        sudo dnf install -y "$@"

    elif command -v yum >/dev/null; then
        sudo yum install -y "$@"

    elif command -v pacman >/dev/null; then
        sudo pacman -Sy --noconfirm "$@"

    elif command -v apk >/dev/null; then
        sudo apk add "$@"

    else
        die "No supported package manager found"
    fi
}

pkg_remove() {

    if command -v apt >/dev/null; then
        sudo apt remove -y "$@" || true

    elif command -v dnf >/dev/null; then
        sudo dnf remove -y "$@"

    elif command -v yum >/dev/null; then
        sudo yum remove -y "$@"

    elif command -v pacman >/dev/null; then
        sudo pacman -Rns --noconfirm "$@"

    elif command -v apk >/dev/null; then
        sudo apk del "$@"

    else
        die "No supported package manager found"
    fi
}

pkg_upgrade() {

    if command -v apt >/dev/null; then
        sudo apt update
        sudo apt upgrade -y

    elif command -v dnf >/dev/null; then
        sudo dnf upgrade -y

    elif command -v yum >/dev/null; then
        sudo yum upgrade -y

    elif command -v pacman >/dev/null; then
        sudo pacman -Syu --noconfirm

    elif command -v apk >/dev/null; then
        sudo apk upgrade

    else
        die "No supported package manager found"
    fi
}

########################################
# github install
########################################

github_install() {

    command -v jq >/dev/null ||
        die "jq is required"

    local arch libc url tmp archive bin

    arch="$(detect_arch)" ||
        die "Unsupported architecture: $(uname -m)"

    libc="$(detect_libc)"

    if [[ -z "$PATTERN" ]]; then
        PATTERN="${arch}-unknown-linux-${libc}\.tar\.gz"
    fi

    echo "Searching release asset..."
    url="$(find_release_url "$PATTERN")"

    [[ -n "$url" ]] ||
        die "No matching release asset found"

    echo "Downloading:"
    echo "  $url"

    tmp="$(mktemp -d)"
    trap 'rm -rf "$tmp"' EXIT

    archive="$tmp/archive.tar.gz"

    curl -LfsS "$url" -o "$archive"

    tar -xzf "$archive" -C "$tmp"

    bin="$(
        find "$tmp" \
            -type f \
            -name "$RUNCOMMAND" \
            | head -n1
    )"

    if [[ -z "$bin" ]]; then
        bin="$(
            find "$tmp" \
                -type f \
                -executable \
                ! -name '*.so*' \
                | head -n1
        )"
    fi

    [[ -n "$bin" ]] ||
        die "No executable found"

    mkdir -p "$INSTALL_DIR"

    install -m 755 \
        "$bin" \
        "$INSTALL_DIR/$RUNCOMMAND"

    echo
    echo "Installed:"
    echo "  $INSTALL_DIR/$RUNCOMMAND"
}

########################################
# argument parsing
########################################

while [[ $# -gt 0 ]]; do
    case "$1" in
        -r|--repo)
            REPO="$2"
            shift 2
            ;;

        -a|--app)
            APP_NAME="$2"
            shift 2
            ;;

        -d|--dir)
            INSTALL_DIR="$2"
            shift 2
            ;;

        -p|--pattern)
            PATTERN="$2"
            shift 2
            ;;

        -u|--remove)
            UNINSTALL=true
            shift
            ;;

        -g|--upgrade)
            UPGRADE=true
            shift
            ;;

        --app-force)
            APP_FORCE=true
            shift
            ;;

        --deb-force)
            DEB_FORCE=true
            shift
            ;;

        -h|--help)
            usage
            ;;

        -*)
            die "Unknown option: $1"
            ;;

        *)
            break
            ;;
    esac
done

[[ $# -eq 1 ]] || usage

RUNCOMMAND="$1"

########################################
# default install dir
########################################

if [[ -z "$INSTALL_DIR" ]]; then
    if [[ $EUID -eq 0 ]]; then
        INSTALL_DIR="/usr/local/bin"
    else
        INSTALL_DIR="$HOME/.local/bin"
    fi
fi

########################################
# actions
########################################

if $UNINSTALL; then

    [[ -n "$APP_NAME" ]] &&
        pkg_remove "$APP_NAME"

    rm -f "/usr/local/bin/$RUNCOMMAND"
    rm -f "$(real_home)/.local/bin/$RUNCOMMAND"

    exit 0
fi

if $UPGRADE; then
    pkg_upgrade
    exit 0
fi

if [[ -n "$REPO" && "$APP_FORCE" == false ]]; then
    github_install
    exit 0
fi

if [[ -n "$APP_NAME" ]]; then
    pkg_install "$APP_NAME"
    exit 0
fi

die "Nothing to do"