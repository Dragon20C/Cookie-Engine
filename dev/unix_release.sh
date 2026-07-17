#!/usr/bin/env bash

set -euo pipefail

ENGINE_ROOT="$HOME/CookieEngine"
MODULES_ROOT="./src/scripts/modules"
TEMPLATE_ROOT="./src/template"

main(){

	require_command odin

	require_command zip

	echo "Building Cookie Engine..."

	odin build . -out:cookie

	echo "Syncing runtime files..."

	cp -r $MODULES_ROOT "$ENGINE_ROOT/"
	rm -f "$ENGINE_ROOT/modules/module_loader.odin"
	cp -r $TEMPLATE_ROOT "$ENGINE_ROOT/"
	cp version.txt "$ENGINE_ROOT/"
	cp LICENSE.txt "$ENGINE_ROOT/"
	cp cookie "$ENGINE_ROOT/"

	echo "Done."

	while true; do
    read -rp "Would you like to zip it for release? [y/n]: " answer

    case "$answer" in
        y|Y|yes|YES)
       		tar -czf "$HOME/CookieEngine-linux.tar.gz" -C "$(dirname "$ENGINE_ROOT")" "$(basename "$ENGINE_ROOT")"
         	echo "Zipped in $HOME/CookieEngine-linux.tar.gz"
            break
            ;;
        n|N|no|NO)
            break
            ;;
        *)
            echo "Please enter y or n."
            ;;
    esac
	done

	while true; do
    read -rp "Would you like to run the template project? [y/n]: " answer

    case "$answer" in
        y|Y|yes|YES)
            cookie dev ./src/template
            break
            ;;
        n|N|no|NO)
            break
            ;;
        *)
            echo "Please enter y or n."
            ;;
    esac
	done
}

require_command() {
    if ! command -v "$1" &> /dev/null; then
        echo "Error: Required command '$1' is missing." >&2
        exit 1
    fi
}

main
