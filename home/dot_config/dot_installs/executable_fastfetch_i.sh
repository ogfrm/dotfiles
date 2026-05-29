#!/bin/bash
set -euo pipefail
RUNCOMMAND="fastfetch" # /usr/bin
UPDATE=false && UNINSTALL=false
while getopts ":urs" opt; do
  [[ $opt == u ]] && UPDATE=true
  [[ $opt == r ]] && UNINSTALL=true
done
if [ "$UNINSTALL" = true ]; then
  if command -v $RUNCOMMAND >/dev/null 2>&1; then
    sudo apt remove fastfetch -y
    echo "$RUNCOMMAND uninstallation completed"
  fi
  exit 0
fi
if command -v $RUNCOMMAND >/dev/null 2>&1 && [ "$UPDATE" = false ]; then exit 0; fi
if command -v apt >/dev/null 2>&1; then
  deb=$(curl -s https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest \
  | grep browser_download_url \
  | grep 'fastfetch-linux-amd64\.deb"' \
  | cut -d '"' -f 4)
  curl -LO "$deb" && sudo dpkg -i "$(basename "$deb")" && rm $(basename "$deb")
  sudo apt-get install -f   # If dependencies fail after installation:
  echo "$RUNCOMMAND installation completed"
elif command -v yum >/dev/null 2>&1; then sudo yum install -y fastfetch;
elif command -v pacman >/dev/null 2>&1; then sudo pacman -Sy --noconfirm fastfetch;
elif command -v dnf >/dev/null 2>&1; then sudo dnf install -y fastfetch;
elif command -v apk >/dev/null 2>&1; then sudo apk add -U -q fastfetch;
fi