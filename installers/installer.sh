#!/usr/bin/env bash

echo "Bash version: $BASH_VERSION"
echo ""
echo "Welcome to the cookie engine installer!"
echo ""

bashrc="$HOME/.bashrc"

if ! grep -q "^export COOKIE_ENGINE_ROOT=" "$bashrc"; then
    {
        echo ""
        echo "# Cookie Engine"
        echo 'export COOKIE_ENGINE_ROOT="$HOME/CookieEngine"'
        echo 'export PATH="$PATH:$COOKIE_ENGINE_ROOT/"'
    } >> "$bashrc"

    echo "Added Cookie Engine to ~/.bashrc"
else
    echo "COOKIE_ENGINE_ROOT already exists."
fi

source ~/.bashrc
