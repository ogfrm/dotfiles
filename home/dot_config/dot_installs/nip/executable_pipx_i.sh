#!/usr/bin/env bash
set -euo pipefail

ACTION="${1:-install}"
MODE="${2:---user}"

PIPX="$HOME/.local/bin/pipx"
[ "$MODE" = "--global" ] && PIPX="sudo env PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin pipx"

app_install() {
    [ command -v "pipx" >/dev/null 2>&1 ] && return
    sudo apt update && sudo apt install -y pipx python3-venv

    eval "$PIPX install --force pipx"
    eval "$PIPX ensurepath"
    # python3 -m venv ~/.local/pipx-boot
    # ~/.local/pipx-boot/bin/pip install -U pip pipx
    # ~/.local/pipx-boot/bin/pipx ensurepath
    # export PATH="$HOME/.local/bin:$PATH"
    sudo apt remove -y pipx || true
    sudo apt autoremove -y || true
}

app_upgrade() {
    eval "$PIPX upgrade pipx --include-injected" 2>/dev/null || app_uninstall
    app_install
    eval "$PIPX upgrade-all --include-injected" --pip-args="--upgrade-strategy=eager" || true
}
app_remove_apps() {
    APPS=$($PIPX list --short 2>/dev/null | awk '{print $1}')
    [ -z "$APPS" ] && return
    for app in $APPS; do
        [ "$app" = "pipx" ] && continue
        eval "$PIPX uninstall $app" || true
    done
}
app_uninstall() {
    [[ "${1:-}" == "all" ]] && remove_apps
    eval "$PIPX uninstall pipx"
    if [[ "$MODE" == "--global" ]]; then
        sudo rm -rf "/opt/pipx/venvs/pipx" || true
        sudo rm /usr/local/bin/pipx
        [ "$1" = "all" ] && sudo rm -rf /opt/pipx || true
    else
        rm -rf ~/.local/share/pipx/venvs/pipx || true
        [ "$1" = "all" ] && rm -rf ~/.local/share/pipx || true
        rm ~/.local/bin/pipx
    fi
}
case "$ACTION" in
    install) [ command -v "$RUNCOMMAND" >/dev/null 2>&1 ] && install ;;
    upgrade) upgrade ;;
    uninstall) uninstall ;;
    uninstall_all) uninstall all ;;
    *) echo "  $0 [install|upgrade|uninstall|uninstall_all] [--global]" ;;
esac
