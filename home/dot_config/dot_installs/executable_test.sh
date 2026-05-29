#!/usr/bin/env bash
# compact-dev-setup.sh
# usage:
#   ./compact-dev-setup.sh                # install (default)
#   ./compact-dev-setup.sh install
#   ./compact-dev-setup.sh uninstall
#   ./compact-dev-setup.sh upgrade
#   ./compact-dev-setup.sh install user
#   ./compact-dev-setup.sh install global

set -euo pipefail

ACTION="${1:-install}"
SCOPE="${2:-global}"

PKGS_COMMON="fzf zoxide ripgrep curl wget zsh ncdu tmux jq"
FONT="JetBrainsMono"

[ "$SCOPE" = "user" ] && PREFIX="$HOME/.local" || PREFIX="/usr/local"

detect_os() {
  . /etc/os-release
  echo "${ID,,}"
}

need_sudo() {
  [ "$SCOPE" = "global" ] && [ "$(id -u)" -ne 0 ]
}

SUDO=""
need_sudo && SUDO="sudo"

install_fonts() {
  mkdir -p "$HOME/.local/share/fonts"
  curl -fsSL \
    "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FONT}.zip" \
    -o /tmp/font.zip >/dev/null 2>&1
  unzip -oq /tmp/font.zip -d "$HOME/.local/share/fonts/$FONT" >/dev/null 2>&1
  fc-cache -f >/dev/null 2>&1 || true
}

install_extras() {
  # fastfetch
  command -v fastfetch >/dev/null || {
    curl -fsSL https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-amd64.deb \
      -o /tmp/ff.deb >/dev/null 2>&1 || true
  }

  # starship
  command -v starship >/dev/null || \
    curl -fsSL https://starship.rs/install.sh | sh -s -- -y -b "$PREFIX/bin" >/dev/null 2>&1

  # oh-my-posh
  command -v oh-my-posh >/dev/null || \
    curl -fsSL https://ohmyposh.dev/install.sh | bash -s -- -d "$PREFIX/bin" >/dev/null 2>&1

  # pipx
  command -v pipx >/dev/null || python3 -m pip install --user -q pipx >/dev/null 2>&1 || true

  # bat symlink
  command -v batcat >/dev/null && ! command -v bat >/dev/null && \
    $SUDO ln -sf "$(command -v batcat)" /usr/local/bin/bat >/dev/null 2>&1 || true
}

setup_shell() {
  grep -q "starship init" ~/.zshrc 2>/dev/null || \
    echo 'eval "$(starship init zsh)"' >> ~/.zshrc

  grep -q "zoxide init" ~/.zshrc 2>/dev/null || \
    echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc

  grep -q "oh-my-posh init" ~/.zshrc 2>/dev/null || \
    echo 'eval "$(oh-my-posh init zsh)"' >> ~/.zshrc
}

install_pkgs() {
  OS="$(detect_os)"

  case "$OS" in
    ubuntu|debian)
      $SUDO apt-get update -qq
      $SUDO apt-get install -y -qq \
        $PKGS_COMMON fastfetch bat unzip fontconfig python3-pip >/dev/null
      ;;
    alpine)
      $SUDO apk add --no-cache \
        $PKGS_COMMON fastfetch bat unzip fontconfig python3 py3-pip >/dev/null
      ;;
    arch)
      $SUDO pacman -Sy --noconfirm \
        $PKGS_COMMON fastfetch bat unzip fontconfig python-pip >/dev/null
      ;;
    fedora)
      $SUDO dnf install -y -q \
        $PKGS_COMMON fastfetch bat unzip fontconfig python3-pip >/dev/null
      ;;
    *)
      echo "unsupported os"
      exit 1
      ;;
  esac

  install_extras
  install_fonts
  setup_shell
}

uninstall_pkgs() {
  OS="$(detect_os)"

  case "$OS" in
    ubuntu|debian)
      $SUDO apt-get remove -y -qq fastfetch fzf zoxide ripgrep curl wget zsh ncdu bat tmux jq >/dev/null
      ;;
    alpine)
      $SUDO apk del fastfetch fzf zoxide ripgrep curl wget zsh ncdu bat tmux jq >/dev/null
      ;;
    arch)
      $SUDO pacman -Rns --noconfirm fastfetch fzf zoxide ripgrep curl wget zsh ncdu bat tmux jq >/dev/null
      ;;
    fedora)
      $SUDO dnf remove -y -q fastfetch fzf zoxide ripgrep curl wget zsh ncdu bat tmux jq >/dev/null
      ;;
  esac

  rm -rf "$HOME/.local/share/fonts/$FONT" >/dev/null 2>&1 || true
}

upgrade_pkgs() {
  OS="$(detect_os)"

  case "$OS" in
    ubuntu|debian)
      $SUDO apt-get update -qq && $SUDO apt-get upgrade -y -qq >/dev/null
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
}

case "$ACTION" in
  install) install_pkgs ;;
  uninstall) uninstall_pkgs ;;
  upgrade) upgrade_pkgs ;;
  *) echo "usage: $0 [install|uninstall|upgrade] [global|user]" ;;
esac