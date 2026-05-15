#!/usr/bin/env bash
set -euo pipefail
app_install() {
  command -v ansible >/dev/null 2>&1 && return
  command -v pipx >/dev/null 2>&1 || { sudo apt update && sudo apt install pipx -y; }
  pipx install --include-deps ansible
  pipx install ansible-lint
  ansible-galaxy collection install community.general --force
  ansible-galaxy collection install community.docker --force
}

app_uninstall() {

  command -v ansible >/dev/null 2>&1 || {
    echo "ansible not installed"
    return
  }
  pipx uninstall ansible-core
  pipx uninstall ansible
  pipx uninstall ansible-lint
# echo "Done"
  # sudo apt-get remove ansible
  # sudo apt-get purge ansible
  # sudo apt-get autoremove
}

ACTION="${1:-install}"
echo "$ACTION ansible"
case "$ACTION" in
  install) app_install  ;;
  uninstall) app_uninstall  ;;
esac
echo "Done"
