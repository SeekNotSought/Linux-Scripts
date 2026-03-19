#!/usr/bin/env bash

# ============================================================
# Export group memberships for a list of users into a CSV file
# Works on most Linux distros (Ubuntu, Debian, RHEL, Fedora)
# ============================================================

INPUT_FILE="$1"
OUTPUT_FILE="$2"

if [[ -z "$INPUT_FILE" || -z "$OUTPUT_FILE" ]]; then
    echo "Usage: $0 <user_list.txt> <output.csv>"
    exit 1
fi

if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Error: Input file '$INPUT_FILE' not found."
    exit 1
fi

# Write CSV header
echo "username,groups" > "$OUTPUT_FILE"

# Process each username
while IFS= read -r username; do
    username=$(echo "$username" | xargs)  # trim whitespace

    if [[ -z "$username" ]]; then
        continue
    fi

    # Check if user exists
    if id "$username" &>/dev/null; then
        groups=$(id -nG "$username" | tr ' ' ',')
        echo "$username,$groups" >> "$OUTPUT_FILE"
    else
        echo "$username,USER_NOT_FOUND" >> "$OUTPUT_FILE"
    fi

done < "$INPUT_FILE"

echo "CSV created: $OUTPUT_FILE"