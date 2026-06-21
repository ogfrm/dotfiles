#!/bin/bash
set -euo pipefail
# SCRIPT_DIR="$( \cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
SCRIPT_DIR="$HOME/.config/.installs";

# alias czremove_all="chezmoi cat ~/.config/.installs/install_all_i.sh | bash -s -- -r"  # to run this

sudo $SCRIPT_DIR/i_install -i curl unzip git wget tar jq less
# sudo $SCRIPT_DIR/i_install --fonts CascadiaCode,FiraCode,Meslo,JetBrainsMono -i nerdfonts

# {{ include "dotconfig/dot_rc/${name}_i.sh.sh" | sha256sum }}
APPINSTALL_ALL="oh-my-posh starship zoxide fzf fastfetch fresh eza fd ripgrep tmux bat"
# sudo $SCRIPT_DIR/i_install -u $APPINSTALL_ALL
# sudo $SCRIPT_DIR/i_install -i -g $APPINSTALL_ALL
# sudo $SCRIPT_DIR/i_install -i -g pipx ansible

# ./nerdfonts_i.sh install CascadiaCode FiraCode Meslo JetBrainsMono

# rm $0  # Delete me