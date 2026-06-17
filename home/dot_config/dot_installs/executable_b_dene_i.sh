#!/usr/bin/env bash
set -euo pipefail

# if command -v apt >/dev/null 2>&1; then
#   [[ $EUID -eq 0 ]] && PATTERN_LIST+=("-linux-${ARCH//x86_64/amd64}.deb")
# fi
# $ISALPINE && PATTERN_LIST+=("${ARCH}-unknown-linux-musl.tar.gz")
# PATTERN_LIST+=("${ARCH}-unknown-linux-gnu.tar.gz")
# $ISALPINE || PATTERN_LIST+=("${ARCH}-unknown-linux-musl.tar.gz")
# PATTERN_LIST+=("-linux-${ARCH}.tar.gz")
# PATTERN_LIST+=("-linux-amd64.tar.gz")
# PATTERN_LIST+=("_Linux_${ARCH}.tar.gz")
# PATTERN_LIST+=("-linux-${ARCH}")
# PATTERN_LIST+=("-linux-amd64")


git_latest_url() {
    local pattern="$1"
    printf '%s\n' "$RELEASE_JSON" |
      { if command -v jq >/dev/null 2>&1; then
          jq -r --arg p "$pattern" '.assets[].browser_download_url | select(contains($p))'
          # jq -r ".assets[].browser_download_url | select(test(\"$pattern\"))"
        else
          grep '"browser_download_url"' | grep "$pattern" | cut -d'"' -f4
        fi
      } | head -n1
}
git_install() {
  [[ -n "$ARCH" ]] || { echo "Unsupported architecture: $(uname -m)"; return 1; }

  for EXT in "${PATTERN_EXT[@]}"; do
    for PATTERN in "${PATTERN_LIST[@]}"; do
      local URL=$(git_latest_url "$PATTERN$EXT")
      [[ -n "$URL" ]] && break
      local URL=$(git_latest_url "${PATTERN//x86_64/amd64}$EXT")
      [[ -n "$URL" ]] && break
    done
    [[ -n "$URL" ]] && break
  done
    [[ -n "$URL" ]] || { echo "  No release asset matching '$ARCH'"; return 1; }
    echo ---$URL---

}
bottom-musl_0.12.3-1_amd64.deb
bottom-musl_0.12.3-1_arm64.deb
bottom-musl_0.12.3-1_armhf.deb
bottom_0.12.3-1_amd64.deb
bottom_0.12.3-1_arm64.deb
bottom_0.12.3-1_armhf.deb
bottom_aarch64-unknown-linux-gnu.tar.gz
bottom_aarch64-unknown-linux-musl.tar.gz
bottom_x86_64-unknown-linux-gnu.tar.gz
bottom_x86_64-unknown-linux-musl.tar.gz
