#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$( \cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
"$SCRIPT_DIR/ins_git_latest_i.sh" "$@" --repo "BurntSushi/ripgrep" --app ripgrep rg