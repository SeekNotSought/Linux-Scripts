#!/usr/bin/env bash

# ============================================================
# List all files in a directory and output their permissions
# Works on all Linux distributions
# ============================================================

OUTPUT_FILE="file_permissions.txt"

# Ensure a directory was provided
if [[ -z "$1" ]]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

TARGET_DIR="$1"

# Validate directory
if [[ ! -d "$TARGET_DIR" ]]; then
    echo "Error: '$TARGET_DIR' is not a directory."
    exit 1
fi

echo "Collecting file permissions from: $TARGET_DIR"
echo "File Path | Permissions | Owner | Group" > "$OUTPUT_FILE"

# Walk directory and capture permissions
while IFS= read -r -d '' file; do
    perms=$(stat -c "%A" "$file")
    owner=$(stat -c "%U" "$file")
    group=$(stat -c "%G" "$file")
    echo "$file | $perms | $owner | $group" >> "$OUTPUT_FILE"
done < <(find "$TARGET_DIR" -type f -print0)

echo "Done. Output saved to: $OUTPUT_FILE"