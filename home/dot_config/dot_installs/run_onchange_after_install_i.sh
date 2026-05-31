#!/bin/bash
set -euo pipefail

echo ddddd
# czupdate_all2() {
#  cd ~/.config/.installs
#  chezmoi cat ~/.config/.installs/install_i.sh | bash -s -- -u  # to re-run this
# }

# alias czremove_all="chezmoi cat ~/.config/.installs/install_i.sh | bash -s -- -r"  # to re-run this
SCRIPT_DIR="$( \cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
[ -f "$SCRIPT_DIR/install_all_i.sh" ] && "$SCRIPT_DIR/install_all_i.sh"
