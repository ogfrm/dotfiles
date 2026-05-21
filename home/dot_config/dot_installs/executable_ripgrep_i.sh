#!/bin/bash
set -euo pipefail
# /usr/bin/rg
RUNCOMMAND="rg"
UPDATE=false && UNINSTALL=false
while getopts ":ur" opt; do
  [[ $opt == u ]] && UPDATE=true
  [[ $opt == r ]] && UNINSTALL=true
done
if [ "$UNINSTALL" = true ]; then # /usr/bin
  if command -v $RUNCOMMAND >/dev/null 2>&1; then
    sudo apt remove ripgrep -y
    echo "ripgrep uninstallation completed"
  fi
  exit 0
fi
if command -v $RUNCOMMAND >/dev/null 2>&1 && [ "$UPDATE" = false ]; then exit 0; fi

deb=$(curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest \
| grep browser_download_url \
| grep '\.deb"' \
| cut -d '"' -f 4)
curl -LO "$deb" && sudo dpkg -i "$(basename "$deb")" && rm $(basename "$deb")
# If dependencies fail after installation:
sudo apt-get install -f