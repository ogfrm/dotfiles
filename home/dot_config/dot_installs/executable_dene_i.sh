#!/usr/bin/env bash
set -euo pipefail
# echo "$@"
# [[ -w folder ]] checks if a specific folder is writable.

UNINSTALL=false; APP_FORCE=false; UPDATE=false;

while [[ $# -gt 0 ]]; do
    case "$1" in
        -u|--remove) UNINSTALL=true; shift 1 ;;
        -g|--upgrade) UPDATE=true; shift 1 ;;
        --app-force) APP_FORCE=true; shift 1 ;;
        # -h|--help) usage ;;
        # --) shift; break ;;
        -*) echo "Unknown option: $1"; usage ;;
        *) break ;;
    esac
done

# [[ $# -eq 1 ]] || usage
# RUNCOMMAND="$1"
case "$(uname -m)" in
    x86_64) ARCH="x86_64" ;;
    aarch64|arm64) ARCH="aarch64" ;;
    *) ARCH="" ;;
esac
ISALPINE=false
grep -qi alpine /etc/os-release 2>/dev/null ||
(command -v ldd >/dev/null && ldd --version 2>&1 | grep -qi musl) && ISALPINE=true

PATTERN_LIST=()
$ISALPINE && PATTERN_LIST+=("${ARCH}-unknown-linux-musl")
PATTERN_LIST+=("${ARCH}-unknown-linux-gnu")
$ISALPINE || PATTERN_LIST+=("${ARCH}-unknown-linux-musl")
$ISALPINE && PATTERN_LIST+=("musl-linux-${ARCH}")
PATTERN_LIST+=("_${ARCH}")
PATTERN_LIST+=("gnu-linux-${ARCH}")
$ISALPINE || PATTERN_LIST+=("musl-linux-${ARCH}")
PATTERN_LIST+=("-linux-${ARCH}")
PATTERN_LIST+=("_Linux_${ARCH}")
PATTERN_LIST+=("_linux_${ARCH}")
PATTERN_EXT=(".deb" ".tar.gz" "")


# if command -v apt >/dev/null 2>&1; then
#   [[ $EUID -eq 0 ]] && PATTERN_LIST+=("-linux-${ARCH//x86_64/amd64}.deb")
# fi
# $ISALPINE && PATTERN_LIST+=("${ARCH}-unknown-linux-musl.tar.gz")
# PATTERN_LIST+=("${ARCH}-unknown-linux-gnu.tar.gz")
# $ISALPINE || PATTERN_LIST+=("${ARCH}-unknown-linux-musl.tar.gz")
# PATTERN_LIST+=("-linux-${ARCH}.tar.gz")
# PATTERN_LIST+=("-linux-amd64.tar.gz")
# PATTERN_LIST+=("_Linux_${ARCH}.tar.gz")
# PATTERN_LIST+=("-linux-${ARCH}")
# PATTERN_LIST+=("-linux-amd64")

echo "${PATTERN_LIST[@]}"
echo "${#PATTERN_LIST[@]}" # length

# --- Helper functions ---
real_user() { echo "${SUDO_USER:-$(id -un)}" ; }
real_home() { getent passwd "$(real_user)" | cut -d: -f6 2>/dev/null || echo "$HOME" ; }

git_latest_release() { curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" ; }
git_latest_version() { printf '%s\n' "$RELEASE_JSON" | jq -r '.tag_name' ; }
git_latest_url() {
    local pattern="$1"
    printf '%s\n' "$RELEASE_JSON" |
      { if command -v jq >/dev/null 2>&1; then
          jq -r --arg p "$pattern" '.assets[].browser_download_url | select(contains($p))'
          # jq -r ".assets[].browser_download_url | select(test(\"$pattern\"))"
        else
          grep '"browser_download_url"' | grep "$pattern" | cut -d'"' -f4
        fi
      } | head -n1
}
get_installed_version() {
  if command -v "$RUNCOMMAND" >/dev/null 2>&1; then
    # VERSION_CMD="${VERSION_CMD:-$RUNCOMMAND --version}"
    # VERSION_REGEX="${VERSION_REGEX:-[0-9]+(\.[0-9]+)+}"
      "$RUNCOMMAND" $VERSION_ARG 2>/dev/null | grep -Eo '[0-9]+(\.[0-9]+[a-z]?)+' | head -n1
  fi
}
needs_upgrade() {
    [[ -z "$INSTALLED_VERSION" ]] && return 0
    local latest="${LATEST_VERSION#v}"
    local current="${INSTALLED_VERSION#v}"
    [[ "$latest" != "$current" ]]
}
git_install() {
  [[ -n "$ARCH" ]] || { echo "Unsupported architecture: $(uname -m)"; return 1; }
  TMPDIR=$(mktemp -d); trap 'rm -rf "$TMPDIR"' EXIT
  echo "Installing $RUNCOMMAND..."

  RELEASE_JSON=$(git_latest_release)
  LATEST_VERSION=$(git_latest_version)
  INSTALLED_VERSION=$(get_installed_version)
  echo "  Installed: ${INSTALLED_VERSION:-none}"
  echo "  Latest:    $LATEST_VERSION"
  if ! needs_upgrade; then
    echo "  $RUNCOMMAND is already up to date."
    return 0
  fi
  # Determine libc / Alpine
  if [[ -n "$INSTALL_URL" ]]; then
    curl -s https://raw.githubusercontent.com/$REPO/$INSTALL_URL | sh -s -- $INSTALL_URL_ARG >/dev/null 2>&1
  else
  for EXT in "${PATTERN_EXT[@]}"; do
    for PATTERN in "${PATTERN_LIST[@]}"; do
      local URL=$(git_latest_url "$PATTERN$EXT")
      [[ -n "$URL" ]] && break
      local URL=$(git_latest_url "${PATTERN//x86_64/amd64}$EXT")
      [[ -n "$URL" ]] && break
    done
    [[ -n "$URL" ]] && break
  done
    [[ -n "$URL" ]] || { echo "  No release asset matching '$ARCH'"; return 1; }
    echo ---$URL---

    if [[ "$URL" == *.tar.gz ]]; then
      curl -fsSL "$URL" -o "$TMPDIR/archive.tar.gz"
      tar -xzf "$TMPDIR/archive.tar.gz" -C "$TMPDIR"
    elif [[ "$URL" == *.deb ]]; then
      curl -fsSL "$URL" -o "$TMPDIR/archive.deb"
      dpkg -i "$TMPDIR/archive.deb" >/dev/null 2>&1
      apt-get install -fy >/dev/null 2>&1    # If dependencies fail after installation:
    else
      curl -fsSL "$URL" -o "$TMPDIR/$RUNCOMMAND"
    fi
    BIN=$(find "$TMPDIR" -type f -name "$RUNCOMMAND" | head -n1)
    [[ -f "$BIN" ]] || BIN=$(find "$TMPDIR" -type f -perm -111 ! -name '*.so*' ! -name '*.dll' ! -name '*.dylib' | head -n1)
    [[ -f "$BIN" ]] || { echo "  No executable found in archive"; return 1; }

    mkdir -p "$INSTALL_DIR"
    install -m 755 "$BIN" "$INSTALL_DIR/$RUNCOMMAND"
    # chmod 755 "$INSTALL_BIN"
    # [[ -n "$SUDO" ]] && sudo chown root:root "$INSTALL_BIN"
    # $SUDO mv "$INSTALL_BIN" "$INSTALL_DIR/$RUNCOMMAND"
    rm -rf "$TMPDIR"
    echo "  Installed $RUNCOMMAND version $(get_installed_version) -> $INSTALL_DIR/$RUNCOMMAND"
  fi
}

app_uninstall_all() {
    echo $(real_home)
    echo "$@"
  # if command -v $RUNCOMMAND >/dev/null 2>&1; then
    if command -v apt >/dev/null 2>&1; then sudo apt remove -fy -qq "$@" || true
    elif command -v dnf >/dev/null 2>&1; then sudo dnf remove -y -q "$@"
    elif command -v yum >/dev/null 2>&1; then sudo yum remove -y "$@"
    elif command -v pacman >/dev/null 2>&1; then sudo pacman -Rns --noconfirm "$@"
    elif command -v apk >/dev/null 2>&1; then sudo apk del "$@"
    else echo "No supported package manager found."; return 1
    fi
    rm -f "/usr/local/bin/$RUNCOMMAND"
    rm -f "/usr/local/share/man/man1/$RUNCOMMAND"*
    rm -f "$(real_home)/.local/bin/$RUNCOMMAND"
    rm -f "$(real_home)/.local/share/man/man1/$RUNCOMMAND"*
# rm -i "$(which zoxide)"
# rm -i "$HOME/.local/share/man/man1/zoxide"*
  # fi
}
app_install_all() {
  if command -v apt >/dev/null 2>&1; then sudo apt update && sudo apt install -y "$@";
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

bat_i() { REPO=sharkdp/bat; APP_NAME=bat; RUNCOMMAND=bat ; }
bottom_i() { REPO=ClementTsang/bottom; RUNCOMMAND=bottom ; }
fd_i() { REPO=sharkdp/fd; APP_NAME=fd-find; RUNCOMMAND=fd ; }
eza_i() { REPO=eza-community/eza; APP_NAME=eza; RUNCOMMAND=eza ; }
eza_i_uninstall() {
  echo eza uninstall
  # rm -f "$HOME/.local/bin/eza"
  rm -f "$HOME/.local/share/bash-completion/completions/eza" "$HOME/.local/share/zsh/site-functions/_eza"
  if [[ $EUID -eq 0 ]]; then
    # rm -f "/usr/local/bin/eza"
    rm -f "/usr/local/share/bash-completion/completions/eza" "/usr/local/share/zsh/site-functions/_eza"
    apt remove -y eza || true
    rm -f /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    rm -f /usr/share/bash-completion/completions/eza /usr/share/zsh/site-functions/_eza /usr/local/bin/eza
  fi
}
eza_i_install() {
  echo eza install
  # [[ $EUID -eq 0 ]] && BC="/usr/local/share" || BC="$HOME/.local/share"
  [[ $EUID -eq 0 ]] && BC="/usr/share" || BC="$HOME/.local/share"
  echo $BC
  mkdir -p "$BC/bash-completion/completions" "$BC/zsh/site-functions"
  wget -qO "$BC/bash-completion/completions/eza" https://github.com/eza-community/eza/raw/main/completions/bash/eza
  wget -qO "$BC/zsh/site-functions/_eza" https://github.com/eza-community/eza/raw/main/completions/zsh/_eza
}

for f in "$@"; do
  echo "$f..."
  declare -F "${f}_i" > /dev/null || continue
  INSTALL_DIR=""; REPO=""; APP_NAME=""; PATTERN=""
  INSTALL_URL=""; INSTALL_URL_ARG=""; VERSION_ARG="--version"
  ${f}_i
  $UNINSTALL && {
    app_uninstall_all "$APP_NAME"
    declare -F "${f}_i_uninstall" > /dev/null && ${f}_i_uninstall
    continue; }

  if command -v $RUNCOMMAND >/dev/null 2>&1 && [ "$UPDATE" = false ]; then continue; fi
  if [[ -z "$INSTALL_DIR" ]]; then
      [[ $EUID -eq 0 ]] && INSTALL_DIR="/usr/local/bin" || INSTALL_DIR="$HOME/.local/bin"
  fi
  ! $APP_FORCE && [[ -n "$REPO" ]] && git_install || true
  ##  $APP_FORCE && [[ -n "$REPO" ]] && git_install "$RUNCOMMAND" "$REPO" "$INSTALL_DIR" "$PATTERN"
  ($APP_FORCE || [[ -z "$REPO" ]]) && [[ $EUID -eq 0 ]] && [[ -n "$APP_NAME" ]] && app_install_all "$APP_NAME" || true
  declare -F "${f}_i_install" > /dev/null && ${f}_i_install

  # cmd_path=$(command -v my_command)
  # # Ensure it exists AND starts with "/" (ignoring keywords/builtins/aliases)
  # if [ -n "$cmd_path" ] && [ "${cmd_path#"${cmd_path%%[!/]*}"}" = "/" ]; then
  #     echo "Actual executable file exists."
  # fi
done