#!/usr/bin/env bash

set -euo pipefail

########################################
# Configuration
########################################

ENGINE_NAME="CookieEngine"
REPO="Dragon20C/Cookie-Engine"

LINUX_ARCHIVE="CookieEngine-linux.tar.gz"
MACOS_ARCHIVE="CookieEngine-macos.tar.gz"

ENGINE_ROOT="$HOME/$ENGINE_NAME"
SHELL_RC="$HOME/.bashrc"

########################################
# Globals
########################################

TMP_DIR=""

########################################
# Logging
########################################

info() {
    echo "[INFO] $1"
}

success() {
    echo "[SUCCESS] $1"
}

warning() {
    echo "[WARNING] $1"
}

error() {
    echo "[ERROR] $1"
}

########################################
# Cleanup
########################################

cleanup() {
    [[ -n "$TMP_DIR" ]] && rm -rf "$TMP_DIR"
}

trap cleanup EXIT

########################################
# Dependency checks
########################################

check_dependencies() {

    local deps=(
        curl
        tar
        grep
        mktemp
    )

    for dep in "${deps[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            error "Missing dependency: $dep"
            exit 1
        fi
    done
}

########################################
# Platform
########################################

detect_platform() {

    case "$(uname -s)" in
        Linux)
            ARCHIVE="$LINUX_ARCHIVE"
            ;;

        Darwin)
            ARCHIVE="$MACOS_ARCHIVE"
            ;;

        *)
            error "Unsupported operating system."
            exit 1
            ;;
    esac

    DOWNLOAD_URL="https://github.com/$REPO/releases/latest/download/$ARCHIVE"
}

########################################
# Bashrc
########################################

detect_shell() {
	case "$(basename "$SHELL")" in
    bash)
        SHELL_RC="$HOME/.bashrc"
        ;;

    zsh)
        SHELL_RC="$HOME/.zshrc"
        ;;

    *)
        SHELL_RC="$HOME/.profile"
        ;;
esac
}

setup_environment() {

    if ! grep -q "^export COOKIE_ENGINE_ROOT=" "$SHELL_RC"; then

        {
            echo ""
            echo "# Cookie Engine"
            echo 'export COOKIE_ENGINE_ROOT="$HOME/CookieEngine"'
            echo 'export PATH="$COOKIE_ENGINE_ROOT:$PATH"'
        } >> "$SHELL_RC"

        success "Added COOKIE_ENGINE_ROOT to ~/$SHELL_RC"

    else
        info "COOKIE_ENGINE_ROOT already exists."
    fi
}

########################################
# Download
########################################

download_release() {

    TMP_DIR=$(mktemp -d)

    info "Downloading latest release..."

    if ! curl -fL \
        -o "$TMP_DIR/$ARCHIVE" \
        "$DOWNLOAD_URL"
    then
        error "Download failed."
        exit 1
    fi

    info "Extracting release..."

    tar -xzf "$TMP_DIR/$ARCHIVE" -C "$TMP_DIR"

    if [[ ! -d "$TMP_DIR/$ENGINE_NAME" ]]; then
        error "Downloaded archive is invalid."
        exit 1
    fi

    if [[ ! -f "$TMP_DIR/$ENGINE_NAME/version.txt" ]]; then
        error "version.txt is missing."
        exit 1
    fi
}

########################################
# Version
########################################

get_downloaded_version() {
    read -r DOWNLOADED_VERSION < "$TMP_DIR/$ENGINE_NAME/version.txt"
}

get_installed_version() {

    if [[ -f "$ENGINE_ROOT/version.txt" ]]; then
        read -r INSTALLED_VERSION < "$ENGINE_ROOT/version.txt"
    else
        INSTALLED_VERSION=""
    fi
}

########################################
# Install
########################################

install_engine() {

    rm -rf "$ENGINE_ROOT"
    mv "$TMP_DIR/$ENGINE_NAME" "$HOME/"

    success "Installed Cookie Engine $DOWNLOADED_VERSION"
}

########################################
# Update prompt
########################################

ask_update() {

    while true; do

        echo ""
        printf "Update Cookie Engine? [y/n]: "
        read -r answer

        case "$answer" in

            y|Y|yes|YES)
                install_engine
                return
                ;;

            n|N|no|NO)
                info "Installation cancelled."
                exit 0
                ;;

            *)
                echo "Please enter y or n."
                ;;
        esac

    done
}

########################################
# Main
########################################

main() {

    echo ""
    echo "Cookie Engine Installer"
    echo ""

    check_dependencies

    detect_platform

    detect_shell

    download_release

    get_downloaded_version

    if [[ -d "$ENGINE_ROOT" ]]; then

        get_installed_version

        info "Installed version : $INSTALLED_VERSION"
        info "Latest version    : $DOWNLOADED_VERSION"

        if [[ "$INSTALLED_VERSION" == "$DOWNLOADED_VERSION" ]]; then
            success "Cookie Engine is already up to date."
            exit 0
        fi

        ask_update

    else

        install_engine

    fi

    setup_environment

    echo ""
    echo "Installation complete."
    echo ""
    echo "Restart your terminal or run:"
    echo ""
    echo "    source ~/$SHELL_RC"
    echo ""
}

main
