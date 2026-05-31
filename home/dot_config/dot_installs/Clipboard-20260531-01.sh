#!/usr/bin/env bash
set -euo pipefail

REPO="${1:?owner/repo required}"
BIN="${2:?binary name required}"

ARCH=$(
case $(uname -m) in
  x86_64) echo x86_64 amd64 ;;
  aarch64|arm64) echo aarch64 arm64 ;;
  armv7l) echo armv7 ;;
esac
)

LIBC=$(
grep -qi alpine /etc/os-release 2>/dev/null && echo musl || echo gnu
)

DEST=$([[ $EUID = 0 ]] && echo /usr/local/bin || echo "$HOME/.local/bin")

mkdir -p "$DEST"

command -v jq >/dev/null || {
  echo "jq required"
  exit 1
}

API="https://api.github.com/repos/$REPO/releases/latest"

ASSET=$(
curl -fsSL "$API" |
jq -r '
.assets[]
| [.id,.name,.browser_download_url]
| @tsv' |
while IFS=$'\t' read -r id name url; do

  score=0

  for a in $ARCH; do
    [[ $name =~ $a ]] && ((score+=50))
  done

  [[ $name =~ $LIBC ]] && ((score+=20))
  [[ $name =~ linux ]] && ((score+=20))

  case "$name" in
    *.tar.gz) ((score+=10));;
    *.zip)    ((score+=8));;
    *.deb)    ((score+=6));;
    *.rpm)    ((score+=6));;
  esac

  printf '%s\t%s\t%s\t%s\n' "$score" "$id" "$name" "$url"
done |
sort -rn |
head -1
)

read -r _ ID NAME URL <<<"$ASSET"

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

FILE="$TMP/$NAME"

curl -LfsS "$URL" -o "$FILE"

case "$NAME" in

  *.tar.gz)
    tar -xzf "$FILE" -C "$TMP"
    ;;

  *.zip)
    unzip -qq "$FILE" -d "$TMP"
    ;;

  *.deb)
    sudo dpkg -i "$FILE"
    sudo apt-get -f install -y
    exit 0
    ;;

  *.rpm)
    if command -v dnf >/dev/null; then
      sudo dnf install -y "$FILE"
    else
      sudo rpm -Uvh "$FILE"
    fi
    exit 0
    ;;

  *)
    chmod +x "$FILE"
    install -m755 "$FILE" "$DEST/$BIN"
    ;;
esac

FOUND=$(
find "$TMP" -type f \( \
  -name "$BIN" -o \
  -perm -111 \
\) | head -1
)

install -m755 "$FOUND" "$DEST/$BIN"

if [[ $DEST == "$HOME/.local/bin" ]] &&
   ! echo ":$PATH:" | grep -q ":$HOME/.local/bin:"; then

  SHELLRC="$HOME/.bashrc"

  [[ ${SHELL##*/} == zsh ]] &&
    SHELLRC="$HOME/.zshrc"

  grep -q '.local/bin' "$SHELLRC" 2>/dev/null ||
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELLRC"

  export PATH="$HOME/.local/bin:$PATH"

  echo "Added ~/.local/bin to PATH ($SHELLRC)"
fi

echo "Installed $BIN -> $DEST/$BIN"