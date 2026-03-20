#!/usr/bin/env bash

# ============================================
# Uninstall packages from a list for Linux distros
# Supports: APT, DNF, YUM, Pacman, Zypper
# ============================================

LIST_FILE="$1"

if [[ -z "$LIST_FILE" || ! -f "$LIST_FILE" ]]; then
    echo "Usage: $0 <package_list_file>"
    echo "Package list file not found."
    exit 1
fi

# Detect Linux distribution
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "Unable to detect Linux distribution."
    exit 1
fi

echo "Detected Linux distribution: $DISTRO"
echo

# Function: Check if a package is installed
is_installed() {
    local pkg="$1"

    case "$DISTRO" in
        ubuntu|debian)
            dpkg -l | grep -qw "$pkg"
            ;;
        fedora)
            rpm -q "$pkg" &>/dev/null
            ;;
        centos|rhel)
            rpm -q "$pkg" &>/dev/null
            ;;
        arch)
            pacman -Qi "$pkg" &>/dev/null
            ;;
        opensuse*|suse)
            rpm -q "$pkg" &>/dev/null
            ;;
        *)
            echo "Unsupported distribution: $DISTRO"
            exit 1
            ;;
    esac
}

# Function: Uninstall a package
uninstall_pkg() {
    local pkg="$1"

    case "$DISTRO" in
        ubuntu|debian)
            sudo apt remove -y "$pkg"
            ;;
        fedora)
            sudo dnf remove -y "$pkg"
            ;;
        centos|rhel)
            sudo yum remove -y "$pkg"
            ;;
        arch)
            sudo pacman -Rns --noconfirm "$pkg"
            ;;
        opensuse*|suse)
            sudo zypper remove -y "$pkg"
            ;;
    esac
}

# Process each package in the list
while IFS= read -r pkg || [[ -n "$pkg" ]]; do
    [[ -z "$pkg" ]] && continue  # skip empty lines

    echo "Checking: $pkg"

    if is_installed "$pkg"; then
        echo " → Installed. Uninstalling..."
        uninstall_pkg "$pkg"
        echo " → Uninstalled."
    else
        echo " → Not installed. Skipping."
    fi

    echo
done < "$LIST_FILE"

echo "All done."