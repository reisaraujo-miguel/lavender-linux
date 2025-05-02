#!/bin/bash

set -ouex pipefail

# Constants
export RELEASE
RELEASE="$(rpm -E %fedora)"

# Validate environment
[[ -z "$RELEASE" ]] && {
    echo "Failed to determine Fedora release"
    exit 1
}

# Helper Functions
execute_script() {
    local script="$1"
    local script_path="/ctx/scripts/${script}"

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

    mapfile -t packages <"$pkg_file"

    if dnf5 -y install "${packages[@]}" --allowerasing; then
        return 0
    fi

    return 1
}

remove_packages() {
    local pkg_file="$1"

    mapfile -t packages <"$pkg_file"

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

    echo "::group:: === Install Extra Packages ==="
    install_packages "/ctx/extra-packages"
    echo "::endgroup::"

    echo "::group:: === Remove Unwanted Packages ==="
    remove_packages "/ctx/remove-pkgs"
    echo "::endgroup::"

    echo "::group:: === Configure Desktop Environment ==="
    execute_script "update-system-files.sh"
    echo "::endgroup::"

    echo "::group:: === Configure Ghostty ==="
    execute_script "configure-ghostty.sh"
    echo "::endgroup::"

    echo "::group:: === Unset Extra Repos ==="
    execute_script "unset-extra-repos.sh"
    echo "::endgroup::"
}

main
