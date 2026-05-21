#!/bin/bash

for name in "curl" "unzip" "git" "wget"; do
  if ! command -v $name >/dev/null 2>&1; then
    if command -v apt >/dev/null 2>&1; then sudo apt update && sudo apt install -y $name;
    elif command -v yum >/dev/null 2>&1; then sudo yum install -y $name;
    elif command -v pacman >/dev/null 2>&1; then sudo pacman -Sy --noconfirm $name;
    elif command -v dnf >/dev/null 2>&1; then sudo dnf install -y $name;
    fi
  fi
done

# # {{ include "dotconfig/dot_rc/executable_nerdfonts_i.sh" | sha256sum }}
# ./nerdfonts_i.sh install CascadiaCode FiraCode Meslo JetBrainsMono
# ./pipx_i.sh
# ./ansible_i.sh

# # {{ include "dotconfig/dot_rc/executable_ohmyposh_i.sh" | sha256sum }}
./ohmyposh_i.sh
./starship_i.sh
./zoxide_i.sh
./fzf_i.sh

# system
# # {{ include "fastfetch_i.sh" | sha256sum }}
./fastfetch_i.sh
./fresh_i.sh
./ripgrep_i.sh
