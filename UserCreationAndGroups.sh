#!/usr/bin/env bash

# ============================================================
# Create users and assign groups from a CSV file
# Works on most Linux distros (Ubuntu, Debian, RHEL, Fedora)
# ============================================================

CSV_FILE="$1"

if [[ -z "$CSV_FILE" ]]; then
    echo "Usage: $0 <users.csv>"
    exit 1
fi

if [[ ! -f "$CSV_FILE" ]]; then
    echo "Error: File '$CSV_FILE' not found."
    exit 1
fi

# Read CSV line by line, skipping header
tail -n +2 "$CSV_FILE" | while IFS=',' read -r username groups; do

    # Trim whitespace
    username=$(echo "$username" | xargs)
    groups=$(echo "$groups" | xargs)

    if [[ -z "$username" ]]; then
        echo "Skipping empty username row"
        continue
    fi

    echo "Processing user: $username"

    # Create user if not exists
    if id "$username" &>/dev/null; then
        echo "  User already exists"
    else
        echo "  Creating user..."
        useradd -m "$username"
        passwd -d "$username" 2>/dev/null   # No password set
    fi

    # Process groups
    IFS=';' read -ra group_array <<< "${groups//,/;}"
    for group in "${group_array[@]}"; do
        group=$(echo "$group" | xargs)

        if [[ -z "$group" ]]; then
            continue
        fi

        # Check if group exists
        if getent group "$group" > /dev/null; then
            echo "  Adding $username to group: $group"
            usermod -aG "$group" "$username"
        else
            echo "  WARNING: Group '$group' does not exist. Skipping."
            # To auto-create groups, uncomment:
            # groupadd "$group"
            # usermod -aG "$group" "$username"
        fi
    done

    echo "Done with $username"
    echo "----------------------------------------"

done