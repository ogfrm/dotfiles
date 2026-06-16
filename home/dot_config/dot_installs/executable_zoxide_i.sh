#!/bin/bash
set -euo pipefail
# https://github.com/ajeetdsouza/zoxide#installation
# winget install ajeetdsouza.zoxide   Invoke-Expression (& { (zoxide init powershell | Out-String) })
RUNCOMMAND="zoxide" # ~/.local/bin/zoxide
SCRIPT_DIR="$( \cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
[[ $EUID -eq 0 ]] && INSTALL_DIR="/usr/local" || INSTALL_DIR="$HOME/.local"
"$SCRIPT_DIR/install_i.sh" "$@" --repo "ajeetdsouza/zoxide" --install_url "main/install.sh" --install_url_arg "--bin-dir ${INSTALL_DIR}/bin --man-dir ${INSTALL_DIR}/share/man" --app zoxide zoxide
# rm -i "$HOME/.local/share/man/man1/zoxide"*

# UPDATE=false && UNINSTALL=false
# while getopts ":ur" opt; do
#   [[ $opt == u ]] && UPDATE=true
#   [[ $opt == r ]] && UNINSTALL=true
# done
# if $UNINSTALL; then
#   rm -f "$HOME/.local/bin/$RUNCOMMAND"
#   echo "$RUNCOMMAND uninstallation completed"
#   exit 0
# fi
# if command -v $RUNCOMMAND >/dev/null 2>&1 && [ "$UPDATE" = false ]; then exit 0; fi
# curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
