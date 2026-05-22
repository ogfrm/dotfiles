#!/bin/bash
set -euo pipefail

# czupdate_all2() {
#  cd ~/.config/.installs
#  chezmoi cat ~/.config/.installs/install_i.sh | bash -s -- -u  # to re-run this
# }

# alias czremove_all="chezmoi cat ~/.config/.installs/install_i.sh | bash -s -- -r"  # to re-run this
[ ! -f "./install_all_i.sh" ] && "./install_all_i.sh"
