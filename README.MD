Setup steps.

1: change into the root of cookie-engine folder being inside a terminal

2: Run this command : odin build ./cli

3: Then run that new created executable named cli.bin with these args



"new" keyword is used for creating a new project
after "new" a game name is required, note it must not include special characters or spaces
after that a path/location where you want to store your game, note you can leave the path out and it create it in the current dir

COMMAND BELOW
./cli.bin new game_name ../my/desired/path

"run" keyword is used for running the game, all it requires it a path or no path if already in the game folder
"dev" is also another keyword that replaces run, this makes the game run in dev mode which allows you to have extra debug features
that you code in, you can for example use cookie.IS_DEV boolean to only apply debug features.

COMMAND BELOW (Replace run with dev if want dev mode)
./cli.bin run ../my/desired/path
