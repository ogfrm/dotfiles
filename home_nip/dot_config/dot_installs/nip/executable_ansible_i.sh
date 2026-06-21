#!/usr/bin/env bash
set -euo pipefail
app_install() {
  command -v ansible >/dev/null 2>&1 && return
  command -v pipx >/dev/null 2>&1 || { sudo apt update && sudo apt install pipx -y; }
  pipx install --include-deps ansible
  pipx inject ansible passlib # needed for ansible.builtin.password_hash
  pipx inject ansible jmespath # needed for community.general.json_query
  pipx install ansible-lint
  pipx inject ansible paramiko # needed for community.general.ssh_config
  ansible-galaxy collection install community.general --force
  ansible-galaxy collection install community.docker --force
  ansible-galaxy collection install ansible.posix --upgrade
  ansible-galaxy collection install community.proxmox

  sudo apt install python3-paramiko # needed for community.general.ssh_config install as apt

# ansible-galaxy collection install -U $(ansible-galaxy collection list --format json | jq -r '.[] | keys []')
  # sudo apt install ansible python3-passlib # needed for ansible.builtin.password_hash
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
