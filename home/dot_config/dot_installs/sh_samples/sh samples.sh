#!/bin/bash
SCRIPTROOT=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


#echo "[$0] vs. [${BASH_SOURCE[0]}]"

echo S = $SCRIPTROOT
echo "*" = "${0%/*}"
dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
echo d = "$dir"
cd "${BASH_SOURCE%/*}" || exit
pwd
cd "$(dirname "${BASH_SOURCE[0]}")"
pwd
echo ------------


# Delete me
rm $0