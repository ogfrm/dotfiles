#!/bin/bash
set -euo pipefail
# https://github.com/ajeetdsouza/zoxide#installation
# winget install ajeetdsouza.zoxide   Invoke-Expression (& { (zoxide init powershell | Out-String) })
RUNCOMMAND="zoxide" # ~/.local/bin/zoxide
UPDATE=false && UNINSTALL=false
while getopts ":urs" opt; do
  [[ $opt == u ]] && UPDATE=true
  [[ $opt == r ]] && UNINSTALL=true
done
if [ "$UNINSTALL" = true ]; then
  if command -v $RUNCOMMAND >/dev/null 2>&1
    [[ -f "$HOME/.local/bin/$RUNCOMMAND" ]] && rm "$HOME/.local/bin/$RUNCOMMAND"
    echo "$RUNCOMMAND uninstallation completed"
  fi
  exit 0
fi
if command -v $RUNCOMMAND >/dev/null 2>&1 && [ "$UPDATE" = false ]; then exit 0; fi
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
