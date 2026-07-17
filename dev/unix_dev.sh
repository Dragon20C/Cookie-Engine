#!/usr/bin/env bash

set -euo pipefail

TEMPLATE_DIR="./src/template"

main(){

	require_command odin

	echo "Welcome!"
	echo ""
	echo "This script will build cookie engine and run the template dir located in ./src/template"
	echo "if for some reason you added new files, I recommend running the unix_release.sh file first"
	echo "so that the engine binary can see it."
	sleep 2

	if [[ ! -e main.odin ]] then
		echo "main.odin not found, exiting..."
		exit 1
	fi

	echo "Building cookie engine..."

	odin build . -out:cookie

	./cookie dev $TEMPLATE_DIR

	echo "Done"

}

require_command() {
    if ! command -v "$1" &> /dev/null; then
        echo "Error: Required command '$1' is missing." >&2
        exit 1
    fi
}

main
