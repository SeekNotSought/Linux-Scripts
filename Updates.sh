#!/usr/bin/env bash

# Detect kernel type
KERNEL=$(uname -s)

echo "Detected kernel: $KERNEL"
echo

case "$KERNEL" in
    Linux)
        # Detect Linux distribution
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            DISTRO=$ID
        else
            echo "Unable to detect Linux distribution."
            exit 1
        fi

        echo "Detected Linux distribution: $DISTRO"
        echo

        case "$DISTRO" in
            ubuntu|debian)
                echo "Running APT update..."
                sudo apt update && sudo apt upgrade -y
                ;;
            fedora)
                echo "Running DNF update..."
                sudo dnf upgrade --refresh -y
                ;;
            centos|rhel)
                echo "Running YUM update..."
                sudo yum update -y
                ;;
            arch)
                echo "Running Pacman update..."
                sudo pacman -Syu --noconfirm
                ;;
            opensuse*|suse)
                echo "Running Zypper update..."
                sudo zypper refresh && sudo zypper update -y
                ;;
            *)
                echo "Unsupported Linux distribution: $DISTRO"
                exit 1
                ;;
        esac
        ;;

    *)
        echo "Unsupported kernel type: $KERNEL"
        exit 1
        ;;
esac

echo
echo "Update process completed."