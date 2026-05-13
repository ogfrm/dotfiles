#!/usr/bin/env python3
# echo "Hello! @World" | ~/.config/.installs/escape_chars.py
# perl -pe 's/([^a-zA-Z0-9\n])/sprintf("\\u%04x", ord($1))/ge' input.txt

# \cat ~/.config/nerd-font-symbols.toml | ~/.config/.installs/escape_chars.py >~/.config/nerd-font-symbols2.toml
# python3 -c "print('©'.encode('unicode_escape').decode())"
# Output: \u00a9

# import sys

# def escape_special_chars(text):
#     # Converts non-alphanumeric characters to \uXXXX format
#     return "".join(f"\\u{ord(c):04x}" if not c.isalnum() else c for c in text)

# for line in sys.stdin:
#     sys.stdout.write(escape_special_chars(line))


import sys
import re

# Read input
input_text = sys.stdin.read()

# Replace characters in the range E000-F8FF (Nerd Fonts PUA)
def replace_with_unicode(match):
    char = match.group(0)
    return char.encode('unicode-escape').decode('utf-8')

# return ascii(char)

# Regex to find Nerd Font symbols
# result = re.sub(r'[\uE000-\uF8FF]', replace_with_unicode, input_text)
# Include supplementary private-use planes too
result = re.sub(
    r'[\u2000-\uF8FF\U000F0000-\U0010FFFF]',
    replace_with_unicode,
    input_text
)

sys.stdout.write(result)
