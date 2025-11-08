#!/bin/bash

set -ouex pipefail

# Constants
export RELEASE
RELEASE="$(rpm -E %fedora)"

export BUILD_FILES_DIR="/ctx/"

# Validate environment
[[ -z "$RELEASE" ]] && {
    echo "Failed to determine Fedora release"
    exit 1
}

# Helper Functions
execute_script() {
    local script="$1"
    local script_path="$BUILD_FILES_DIR/scripts/${script}"

    if [[ ! -x "$script_path" ]]; then
        echo "Error: Script ${script} not found or not executable"
        return 1
    fi

    echo "Executing ${script}..."
    "$script_path" || {
        echo "Error: ${script} failed"
        return 1
    }
}

install_packages() {
    local pkg_file="$1"

    # Read packages, filtering out comment (starting with #) and blank lines
    mapfile -t packages < <(grep -v '^#\|^$' "$pkg_file")

    if dnf5 -y install "${packages[@]}" --allowerasing; then
        return 0
    fi

    return 1
}

remove_packages() {
    local pkg_file="$1"

    # Read packages, filtering out comment (starting with #) and blank lines
    mapfile -t packages < <(grep -v '^#\|^$' "$pkg_file")

    if dnf5 -y remove "${packages[@]}"; then
        return 0
    fi

    return 1
}

# Main Installation Steps
main() {
    echo "::group:: === Set Extra Repos ==="
    execute_script "set-extra-repos.sh"
    echo "::endgroup::"

    echo "::group:: === Upgrade ==="
    dnf5 -y upgrade
    echo "::endgroup::"

    echo "::group:: === Install Extra Packages ==="
    install_packages "$BUILD_FILES_DIR/extra-pkgs"
    echo "::endgroup::"

    echo "::group:: === Remove Unwanted Packages ==="
    remove_packages "$BUILD_FILES_DIR/remove-pkgs"
    echo "::endgroup::"

    echo "::group:: === Configure Desktop Environment ==="
    execute_script "update-system-files.sh"
    echo "::endgroup::"

    echo "::group:: === Unset Extra Repos ==="
    execute_script "unset-extra-repos.sh"
    echo "::endgroup::"
}

main
