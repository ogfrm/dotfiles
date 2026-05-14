#!/usr/bin/env python3
# echo "Hello! @World" | ~/.config/.installs/escape_chars.py
# perl -pe 's/([^a-zA-Z0-9\n])/sprintf("\\u%04x", ord($1))/ge' input.txt

# \cat ~/.config/nerd-font-symbols.toml | ~/.config/.installs/escape_chars.py >~/.config/nerd-font-symbols2.toml
# python3 -c "print('©'.encode('unicode_escape').decode())"
# Output: \u00a9

import sys
import re
from pathlib import Path

def replace_with_unicode(match):
    char = match.group(0)
    return char.encode('unicode-escape').decode('utf-8')

# Read from file if provided
if len(sys.argv) > 1:
    input_file = Path(sys.argv[1])
    input_text = input_file.read_text(encoding="utf-8")
else:
    input_text = sys.stdin.read()

# Convert unicode characters
result = re.sub(
    r'[\u2000-\uF8FF\U000F0000-\U0010FFFF]',
    replace_with_unicode,
    input_text
)

# Save converted file
if len(sys.argv) > 1:
    output_file = input_file.with_suffix(input_file.suffix + ".converted")
    output_file.write_text(result, encoding="utf-8")
    print(f"Converted file saved as: {output_file}")
else:
    sys.stdout.write(result)
