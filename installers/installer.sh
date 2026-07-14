#!/usr/bin/env bash

echo "Bash version: $BASH_VERSION"
echo ""
echo "Welcome to the cookie engine installer!"
echo ""

dir_name="CookieEngine"
engine_root=$HOME/$dir_name
bashrc="$HOME/.bashrc"

main() {
	if ! grep -q "^export COOKIE_ENGINE_ROOT=" "$bashrc"; then
	    {
	        echo ""
	        echo "# Cookie Engine"
	        echo 'export COOKIE_ENGINE_ROOT="$HOME/CookieEngine"'
	        echo 'export PATH="$PATH:$COOKIE_ENGINE_ROOT/"'
	    } >> "$bashrc"

	    echo "Added Cookie Engine to ~/.bashrc"
	else
	    echo "COOKIE_ENGINE_ROOT already exists in ~/.bashrc."
	fi

	echo ""
	echo "When the install is complete, please restart your terminal or run:"
	echo "source ~/.bashrc"
	echo ""

	if [[ -d "$engine_root" ]]; then
			echo "CookieEngine already exists at $engine_root"
			question_removal_of_dir
	else
			mkdir "$engine_root"
			echo "Created $engine_root"
	fi

}

question_removal_of_dir() {
	echo ""
	echo "Would you like to replace it?"
	echo ""
	while true; do
		echo -n "[y/n]: "
		read -r result
		echo ""
		case "$result" in
		    "yes"| "y" | "YES")
	    	rm -rf "$engine_root"
	    	mkdir "$engine_root"
	        echo "Created a new directory at $engine_root."
	       	break
		;;
		"no" |"n"|"NO")
			echo "No new directory created, be careful if installing new versions."
			break
		;;
		*)
    	echo "Invalid param, Valid params -> [y/n]"
     	;;
	esac
done
}

main
