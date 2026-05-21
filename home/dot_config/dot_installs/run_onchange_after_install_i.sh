#!/bin/bash
set -euo pipefail
[ ! -f "./install_all_i.sh" ] && "./install_all_i.sh"
alias czupdate_all="chezmoi cat ~/.config/.installs/install_i.sh | bash -- -u"  # to re-run this
alias czremove_all="chezmoi cat ~/.config/.installs/install_i.sh | bash -- -r"  # to re-run this
