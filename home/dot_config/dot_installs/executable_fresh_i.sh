#!/bin/bash
set -euo pipefail

RUNCOMMAND="fresh" # /usr/bin
UPDATE=false && UNINSTALL=false
while getopts ":urs" opt; do
  [[ $opt == u ]] && UPDATE=true
  [[ $opt == r ]] && UNINSTALL=true
done
if [ "$UNINSTALL" = true ]; then
  if command -v $RUNCOMMAND >/dev/null 2>&1
    sudo apt remove fresh-editor -y
    echo "$RUNCOMMAND uninstallation completed"
  fi
  exit 0
fi
if command -v $RUNCOMMAND >/dev/null 2>&1 && [ "$UPDATE" = false ]; then exit 0; fi

curl -s https://raw.githubusercontent.com/sinelaw/fresh/refs/heads/master/scripts/install.sh | sh
echo "$RUNCOMMAND installation completed at $INSTALL_DIR."