#!/usr/bin/env bash

# ============================================================
# Export installed applications/packages to a CSV file
# Supports: APT, DNF, YUM, Pacman, Zypper
# ============================================================

OUTPUT_FILE="installed_apps.csv"

# Detect Linux distribution
detect_distro() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        echo "$ID"
    else
        echo "unknown"
    fi
}

DISTRO=$(detect_distro)
echo "Detected Linux distribution: $DISTRO"
echo "Package,Version" > "$OUTPUT_FILE"

# Function: Get installed packages for each distro
get_packages() {
    case "$DISTRO" in
        ubuntu|debian)
            dpkg-query -W -f='${Package},${Version}\n'
            ;;
        fedora)
            rpm -qa --queryformat '%{NAME},%{VERSION}-%{RELEASE}\n'
            ;;
        centos|rhel)
            rpm -qa --queryformat '%{NAME},%{VERSION}-%{RELEASE}\n'
            ;;
        arch)
            pacman -Qi | awk '
                /^Name/ {name=$3}
                /^Version/ {version=$3; print name "," version}
            '
            ;;
        opensuse*|suse)
            rpm -qa --queryformat '%{NAME},%{VERSION}-%{RELEASE}\n'
            ;;
        *)
            echo "Unsupported or unknown distribution: $DISTRO"
            exit 1
            ;;
    esac
}

echo "Collecting installed applications..."
get_packages >> "$OUTPUT_FILE"

echo "Done. Output saved to: $OUTPUT_FILE"