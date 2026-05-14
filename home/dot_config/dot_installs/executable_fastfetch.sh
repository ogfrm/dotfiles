#!/bin/bash
set -euo pipefail

echo 222222
if ! command -v fastfetch &> /dev/null; then
  deb=$(curl -s https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest \
  | grep browser_download_url \
  | grep 'fastfetch-linux-amd64\.deb"' \
  | cut -d '"' -f 4)
  curl -LO "$deb" && sudo dpkg -i "$(basename "$deb")" && rm $(basename "$deb")
  # If dependencies fail after installation:
  sudo apt-get install -f
fi