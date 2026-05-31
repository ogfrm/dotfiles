#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$( \cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
"$SCRIPT_DIR/install_i.sh" "$@" --repo "tmux/tmux-builds" --app tmux tmux
# https://github.com/tmux/tmux  https://github.com/tmux/tmux-builds
