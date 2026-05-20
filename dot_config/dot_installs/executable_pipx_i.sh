#!/usr/bin/env bash
set -euo pipefail
# https://pipx.pypa.io/stable/how-to/install-pipx/

# Pipx installs applications in isolated virtual environments, typically located at  (venvs) and  (app binaries)
# • Virtual Environments (venvs): ~/.local/share/pipx/venvs  (Linux/macOS)
# • Apps (Binaries/Symlinks): ~/.local/bin (Linux/macOS)  (Linux/macOS)
# • Windows Default: ~\\pipx and ~\\.local\\bin
# • Global Installs (): /opt/pipx and /usr/local/bin
# • Logs: Usually found at ~/.local/state/pipx/logs
# • PIPX_HOME: Overrides the default virtual environment location.
# • PIPX_BIN_DIR: Overrides the location where app binaries/symlinks are placed.

app_install() {

  command -v pipx >/dev/null 2>&1 && return
  sudo apt update && sudo apt install pipx -y
  pipx install pipx # Install latest in ~/.local/bin/
  sudo apt purge --autoremove pipx -y # Remove 1.4
  sudo ~/.local/bin/pipx install --global pipx # Install latest in /usr/local/bin/pipx
  # logout and login again, then:
  /usr/local/bin/pipx uninstall pipx
  # pipx uninstall pipx # Remove 1.7 from ~/.local/
  # ll ~/.local/bin/ # Make sure it's empty
  # whereis pipx # will give pipx: /usr/local/bin/pipx

# sudo dnf install pipx  # Fedora:
# python3 -m pip install --user pipx # Using pip on other distributions:
# python3 -m pipx ensurepath

# Distributions (Ubuntu 23.04+, Debian 12+, Fedora 38+) gives externally-managed-environment error. install pipx inside its own virtual environment:
# python3 -m venv ~/.local/share/pipx-venv
# ~/.local/share/pipx-venv/bin/pip install pipx
# ln -s ~/.local/share/pipx-venv/bin/pipx ~/.local/bin/pipx

  pipx ensurepath
  # sudo pipx ensurepath --global
}

app_uninstall() {
  command -v pipx >/dev/null 2>&1 || return
  pipx uninstall-all
  # python3 -m pip uninstall pipx
  sudo apt remove pipx -y
}

ACTION="${1:-install}"
echo "$ACTION pipx"
case "$ACTION" in
  install) app_install  ;;
  uninstall) app_uninstall  ;;
esac
