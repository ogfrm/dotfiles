#!/bin/bash
# ohmyposh.sh hash: {{ include "dotconfig/dot_rc/executable_ohmyposh.sh" | sha256sum }}
./ohmyposh.sh
# fastfetch.sh hash: {{ include "fastfetch.sh" | sha256sum }}
./fastfetch.sh