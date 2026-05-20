#!/bin/bash
set -euo pipefail
if ! command -v fresh &> /dev/null; then
  curl -s https://raw.githubusercontent.com/sinelaw/fresh/refs/heads/master/scripts/install.sh | sh
fi