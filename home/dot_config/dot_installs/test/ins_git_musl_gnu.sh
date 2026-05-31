# Perfect! Let's make it fully adaptive:

# On Alpine, it tries GNU first, but if the download fails or the binary won’t run, it falls back to musl.
# On other Linux, it tries GNU first and falls back to musl.
# We'll even test the binary after extraction to make sure it works before installing
git_install() {
  # Determine architecture
  ARCH=$(uname -m)
  case "$ARCH" in
      x86_64) ARCH="x86_64" ;;
      aarch64|arm64) ARCH="aarch64" ;;
      *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
  esac

  # Detect Alpine or musl
  if grep -qi alpine /etc/os-release 2>/dev/null || (command -v ldd >/dev/null && ldd --version 2>&1 | grep -qi musl); then
      PREFERRED_LIBC="gnu"    # Try GNU first on Alpine if possible
      FALLBACK_LIBC="musl"
  else
      PREFERRED_LIBC="gnu"
      FALLBACK_LIBC="musl"
  fi

  TMPDIR=$(mktemp -d); trap 'rm -rf "$TMPDIR"' EXIT

  find_url() {
      local libc="$1"
      local pattern="${ARCH}-unknown-linux-${libc}.tar.gz"
      curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" |
      (
        command -v jq >/dev/null && jq -r ".assets[].browser_download_url|select(test(\"$pattern\"))" ||
        grep '"browser_download_url"' | grep "$pattern" | cut -d'"' -f4
      ) | head -n1
  }

  download_and_extract() {
      local libc="$1"
      local url
      url=$(find_url "$libc")
      [[ -z "$url" ]] && return 1

      echo "Downloading $url..."
      ARCHIVE="$TMPDIR/archive.tar.gz"
      curl -fsSL "$url" -o "$ARCHIVE"
      tar -xzf "$ARCHIVE" -C "$TMPDIR"

      # Find executable
      BIN=$(find "$TMPDIR" -type f -name "$RUNCOMMAND" | head -n1)
      [[ -f "$BIN" ]] || BIN=$(find "$TMPDIR" -type f -perm -111 ! -name '*.so*' ! -name '*.dll' ! -name '*.dylib' | head -n1)
      [[ -f "$BIN" ]] || return 1

      # Test if executable runs (without args)
      if ! "$BIN" --version >/dev/null 2>&1; then
          return 1
      fi

      return 0
  }

  # Try preferred libc first, fallback if needed
  if ! download_and_extract "$PREFERRED_LIBC"; then
      echo "Preferred libc ($PREFERRED_LIBC) failed, trying fallback ($FALLBACK_LIBC)..."
      if ! download_and_extract "$FALLBACK_LIBC"; then
          echo "No working release asset found for $ARCH (tried $PREFERRED_LIBC and $FALLBACK_LIBC)"
          exit 1
      fi
  fi

  mkdir -p "$INSTALL_DIR"
  install -m 755 "$BIN" "$INSTALL_DIR/$RUNCOMMAND"

  echo "Installed $RUNCOMMAND -> $INSTALL_DIR/$RUNCOMMAND"
}