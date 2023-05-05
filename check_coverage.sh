#!/bin/bash -e

# Use this script to see if Google has introduced new upstream fonts
# which we have not yet packaged.

url="notofonts.github.io"
# Capture all lines between "Scripts" and "Noto Dashboard" (exclusive)
all_scripts=$(w3m -dump "$url" | awk '/Scripts/{flag=1; next} /Noto Dashboard/{flag=0} flag')

# Convert multi-line string to array (each line is new member)
readarray -t scripts <<<"$all_scripts"

for s in "${scripts[@]}"; do
    # strip spaces, tabs, etc. from "$s" before grepping
    if ! grep -iq "${s//[[:blank:]]}" categories.sh; then
        echo "$s from upstream Noto fonts not packaged yet"
    fi
done
