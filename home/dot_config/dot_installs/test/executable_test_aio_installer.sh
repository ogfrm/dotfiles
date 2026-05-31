#!/usr/bin/env bash
set -euo pipefail

# examples:
# ./setup.sh
# ./setup.sh install user fastfetch starship zoxide
# ./setup.sh uninstall global tmux jq
# ./setup.sh upgrade

ACTION="${1:-install}"
SCOPE="${2:-global}"
shift $(( $# >= 1 ? 1 : 0 ))
shift $(( $# >= 1 ? 1 : 0 ))

APPS=("$@")

DEFAULT_APPS=(
  fastfetch fzf nerdfonts oh-my-posh starship
  pipx zoxide ripgrep curl wget zsh
  ncdu bat tmux jq
)

[[ ${#APPS[@]} -eq 0 ]] && APPS=("${DEFAULT_APPS[@]}")

BIN_DIR="$HOME/.local/bin"
FONT_DIR="$HOME/.local/share/fonts"
FONT="JetBrainsMono"

mkdir -p "$BIN_DIR"

detect_os() {
  . /etc/os-release
  echo "${ID,,}"
}

OS="$(detect_os)"

SUDO=""
[[ "$SCOPE" == "global" && "$(id -u)" -ne 0 ]] && SUDO="sudo"

has() {
  [[ " ${APPS[*]} " =~ " $1 " ]]
}

pkg_install() {
  PKGS=()

  for a in "${APPS[@]}"; do
    case "$a" in
      fastfetch|fzf|zoxide|ripgrep|curl|wget|zsh|ncdu|tmux|jq|unzip|fontconfig)
        PKGS+=("$a")
        ;;
      bat)
        [[ "$OS" =~ ubuntu|debian ]] && PKGS+=(batcat) || PKGS+=(bat)
        ;;
      pipx)
        case "$OS" in
          ubuntu|debian) PKGS+=(python3-pip) ;;
          alpine) PKGS+=(python3 py3-pip) ;;
          arch) PKGS+=(python-pip) ;;
          fedora) PKGS+=(python3-pip) ;;
        esac
        ;;
      nerdfonts)
        PKGS+=(unzip fontconfig)
        ;;
    esac
  done

  [[ "$SCOPE" == "user" ]] && return 0
  [[ ${#PKGS[@]} -eq 0 ]] && return 0

  case "$OS" in
    ubuntu|debian)
      $SUDO apt-get update -qq
      $SUDO apt-get install -y -qq "${PKGS[@]}" >/dev/null
      ;;
    alpine)
      $SUDO apk add --no-cache "${PKGS[@]}" >/dev/null
      ;;
    arch)
      $SUDO pacman -Sy --noconfirm "${PKGS[@]}" >/dev/null
      ;;
    fedora)
      $SUDO dnf install -y -q "${PKGS[@]}" >/dev/null
      ;;
  esac
}

install_fastfetch_user() {
  command -v fastfetch >/dev/null && return 0

  ARCH=$(uname -m)

  case "$ARCH" in
    x86_64) FF_ARCH="amd64" ;;
    aarch64|arm64) FF_ARCH="aarch64" ;;
    *) return ;;
  esac

  URL=$(curl -fsSL \
    https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest |
    jq -r ".assets[].browser_download_url" |
    grep "linux-$FF_ARCH.tar.gz" | head -n1)

  curl -fsSL "$URL" -o /tmp/ff.tgz >/dev/null 2>&1
  tar -xzf /tmp/ff.tgz -C /tmp >/dev/null 2>&1

  find /tmp -type f -name fastfetch -exec cp {} "$BIN_DIR/" \;

  chmod +x "$BIN_DIR/fastfetch"
}

install_starship() {
  command -v starship >/dev/null && return 0
  curl -fsSL https://starship.rs/install.sh |
    sh -s -- -y -b "$BIN_DIR" >/dev/null 2>&1
}

install_omp() {
  command -v oh-my-posh >/dev/null && return 0
  curl -fsSL https://ohmyposh.dev/install.sh |
    bash -s -- -d "$BIN_DIR" >/dev/null 2>&1
}

install_pipx() {
  command -v pipx >/dev/null && return 0
  python3 -m pip install --user -q pipx >/dev/null 2>&1 || true
}

install_fonts() {
  mkdir -p "$FONT_DIR"

  curl -fsSL \
    "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FONT}.zip" \
    -o /tmp/font.zip >/dev/null 2>&1

  unzip -oq /tmp/font.zip -d "$FONT_DIR/$FONT" >/dev/null 2>&1

  fc-cache -f >/dev/null 2>&1 || true
}

setup_shell() {
  grep -q "$BIN_DIR" ~/.zshrc 2>/dev/null \
    || echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc

  has starship &&
    ! grep -q "starship init zsh" ~/.zshrc 2>/dev/null &&
    echo 'eval "$(starship init zsh)"' >> ~/.zshrc

  has zoxide &&
    ! grep -q "zoxide init zsh" ~/.zshrc 2>/dev/null &&
    echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc
}

install_all() {
  pkg_install

  for app in "${APPS[@]}"; do
    case "$app" in
      fastfetch)
        [[ "$SCOPE" == "user" ]] && install_fastfetch_user
        ;;
      starship)
        install_starship
        ;;
      oh-my-posh)
        install_omp
        ;;
      pipx)
        install_pipx
        ;;
      nerdfonts)
        install_fonts
        ;;
    esac
  done

  command -v batcat >/dev/null &&
    ! command -v bat >/dev/null &&
    ln -sf "$(command -v batcat)" "$BIN_DIR/bat" 2>/dev/null || true

  setup_shell
}

uninstall_all() {
  if [[ "$SCOPE" == "global" ]]; then
    case "$OS" in
      ubuntu|debian)
        $SUDO apt-get remove -y -qq "${APPS[@]}" >/dev/null 2>&1 || true
        ;;
      alpine)
        $SUDO apk del "${APPS[@]}" >/dev/null 2>&1 || true
        ;;
      arch)
        $SUDO pacman -Rns --noconfirm "${APPS[@]}" >/dev/null 2>&1 || true
        ;;
      fedora)
        $SUDO dnf remove -y -q "${APPS[@]}" >/dev/null 2>&1 || true
        ;;
    esac
  fi

  for app in "${APPS[@]}"; do
    case "$app" in
      fastfetch|starship|oh-my-posh|bat)
        rm -f "$BIN_DIR/$app" 2>/dev/null || true
        ;;
      nerdfonts)
        rm -rf "$FONT_DIR/$FONT" 2>/dev/null || true
        ;;
    esac
  done
}

upgrade_all() {
  if [[ "$SCOPE" == "global" ]]; then
    case "$OS" in
      ubuntu|debian)
        $SUDO apt-get update -qq
        $SUDO apt-get upgrade -y -qq >/dev/null
        ;;
      alpine)
        $SUDO apk upgrade >/dev/null
        ;;
      arch)
        $SUDO pacman -Syu --noconfirm >/dev/null
        ;;
      fedora)
        $SUDO dnf upgrade -y -q >/dev/null
        ;;
    esac
  fi

  install_all
}

case "$ACTION" in
  install) install_all ;;
  uninstall) uninstall_all ;;
  upgrade) upgrade_all ;;
  *)
    echo "usage:"
    echo "  $0 [install|uninstall|upgrade] [global|user] [apps...]"
    exit 1
    ;;
esac