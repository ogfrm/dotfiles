# Instead of hard-coding patterns, assign a score to every release asset and choose the highest-scoring one.
# Example scoring:
# linux	+100
# exact architecture	+100
# alternate architecture name	+90
# preferred libc	+40
# tar.gz	+20
# zip	+15
# deb/rpm	+10
# contains binary name	+20
# source archive	-1000
# checksums/signatures	-1000
score_asset() {
    local name="${1,,}"
    local score=0

    # OS
    [[ $name =~ linux ]] && ((score+=100))

    # Architecture
    case "$ARCH" in
        x86_64)
            [[ $name =~ x86_64 ]] && ((score+=100))
            [[ $name =~ amd64   ]] && ((score+=95))
            ;;
        aarch64)
            [[ $name =~ aarch64 ]] && ((score+=100))
            [[ $name =~ arm64   ]] && ((score+=95))
            ;;
    esac

    # libc preference
    [[ $name =~ $LIBC ]] && ((score+=40))

    # package type
    case "$name" in
        *.tar.gz) ((score+=20));;
        *.zip)    ((score+=15));;
        *.deb)    ((score+=10));;
        *.rpm)    ((score+=10));;
    esac

    # project binary hint
    [[ $name =~ ${BIN,,} ]] && ((score+=20))

    # penalties
    [[ $name =~ checksum ]] && ((score-=1000))
    [[ $name =~ sha256   ]] && ((score-=1000))
    [[ $name =~ sig      ]] && ((score-=1000))
    [[ $name =~ source   ]] && ((score-=1000))
    [[ $name =~ src      ]] && ((score-=1000))

    echo "$score"
}
BEST_ID=
BEST_URL=
BEST_SCORE=-999999

while IFS=$'\t' read -r id name url; do
    score=$(score_asset "$name")

    if (( score > BEST_SCORE )); then
        BEST_SCORE=$score
        BEST_ID=$id
        BEST_URL=$url
    fi
done < <(
    curl -fsSL "$API" |
    jq -r '.assets[] | [.id,.name,.browser_download_url] | @tsv'
)