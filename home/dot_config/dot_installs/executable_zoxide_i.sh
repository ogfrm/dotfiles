#!/bin/bash
set -euo pipefail
# https://github.com/ajeetdsouza/zoxide#installation
# winget install ajeetdsouza.zoxide   Invoke-Expression (& { (zoxide init powershell | Out-String) })
if ! command -v zoxide &> /dev/null; then
# ~/.local/bin/zoxide
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi