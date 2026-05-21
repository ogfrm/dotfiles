#!/bin/bash
set -euo pipefail

UPDATE=false && UNINSTALL=false
while getopts ":urs" opt; do
  [[ $opt == u ]] && UPDATE=true
  [[ $opt == r ]] && UNINSTALL=true
done
if [ "$UNINSTALL" = true && command -v fastfetch >/dev/null 2>&1 ]; then
  sudo apt remove fastfetch -y
  echo "fastfetch uninstallation completed at $INSTALL_DIR."
  exit 0
fi
if command -v fastfetch >/dev/null 2>&1 && [ "$UPDATE" = false ]; then exit 0; fi
if ! command -v curl >/dev/null 2>&1; then
  if command -v apt >/dev/null 2>&1; then sudo apt update && sudo apt install -y curl;
  elif command -v yum >/dev/null 2>&1; then sudo yum install -y curl;
  elif command -v pacman >/dev/null 2>&1; then sudo pacman -Sy --noconfirm curl;
  elif command -v dnf >/dev/null 2>&1; then sudo dnf install -y curl;
  fi
fi

deb=$(curl -s https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest \
| grep browser_download_url \
| grep 'fastfetch-linux-amd64\.deb"' \
| cut -d '"' -f 4)
curl -LO "$deb" && sudo dpkg -i "$(basename "$deb")" && rm $(basename "$deb")
# If dependencies fail after installation:
sudo apt-get install -f
echo "fastfetch installation completed at $INSTALL_DIR."
