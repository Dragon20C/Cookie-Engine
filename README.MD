# <p align ="center"> Cookie Engine </p>

Cookie engine is a 2D game engine perfect for making pixel art games using lua 5.4, **Cookie** uses Odin lang + raylib to run your games, it is powerful and easy to use, it is made by me Dragon20C.

<p align="center">WARNING</p> 
<p align="center"> Cookie engine is experimental and does and will have bugs and issues. </p>

<p align="center"> This project is licensed under the GNU GPL v3.0. See the LICENSE file for details. </p>

# Building

Currently Cookie Engine requires you build the project, in the future there is plans on making it easier to install but for now the only option is to build the project.

## Installation (Linux)

Download the installer:

```sh
curl -LO https://raw.githubusercontent.com/Dragon20C/Cookie-Engine/main/installers/installer.sh
chmod +x installer.sh
./installer.sh
```

The installer will:

- Download the latest Cookie Engine release.
- Install it to `~/CookieEngine`.
- Add `COOKIE_ENGINE_ROOT` to your `~/.bashrc`.
- Add Cookie Engine to your `PATH`.

Note: the installer script exists in this repo in installers directory.

**Instructions**
In a terminal do all of these actions.
Git clone the repo -> https://github.com/Dragon20C/Cookie-Engine

    Git clone https://github.com/Dragon20C/Cookie-Engine
Change directory into cookie engine.

    cd Cookie-Engine
Build the project with odin.

    odin build . -out:cookie

Running the executable.

    ./cookie

Running just cookie prints the available commands.

    new, run, dev, export

 - `./cookie new game_title /desired/game/path` 
**Note :** if path is not provided it creates it at the root of the terminal, also I recommend making the project out of the cookie-engine folder because it can mess up lua language server stuff, do ../ to the path make the project be outside of this folder.
- `./cookie run ./desired/game/path`
**Note :** In the future you would be able to just use ./cookie run but the way I structured the engine requires it go to a specific path.
- `./cookie dev ./desired/game/path`
**Note :** Similar to run except it runs the game in dev mode, dev mode is a simple tool for debugging your games
usage is simply doing cookie.IS_DEV in your lua files, this becomes true if cookie is using dev mode.
- `./cookie export ./desired/game/path`
**Note :** This currently does nothing, so there is no current way to export the project to any systems.



## GFX usage

The GFX library is how you draw in the game engine, you can only draw in the draw function, attempts to draw outside will not work or function at all.
Clears the screen with the selected color **watermelon**

    gfx.clear(gfx.WATERMELON)

There is in total 16 colors avaliable to you, you can see the options in meta/gfx.lua.

Draws a rectangle onto the screen.

    gfx.rectangle(x, y, width, height, color)

Draws a circle onto the screen.

    gfx.circle(x, y, radius, color)

Draws a line between 2 points.   

    gfx.line(x1, y1, x2, y2, color)
Draws text onto the screen at x and y positions with size and color.

    gfx.text(text, x, y, size, Color)

Loads a sprite sheet to the engine, you will need to store this to  a variable

     gfx.load_sheet(cell_width, cell_height, path)

Unload a sprite sheet from the engine, this saves memory

     gfx.unload_sheet(sheet)

Draws a sprite from the sprite sheet, note flip is optional and frame_id wraps around.

     gfx.sprite(sheet, frame_id, x, y, flip)

## Input usage
    input.mouse_position()
Gets the mouse position inside the window.

    input.pressed(input.RIGHT)
   Checks if you have pressed right key **once**.

    input.released(input.RIGHT)
Checks if you have released right key **once**.

    input.held(input.RIGHT)
Checks if you are holding the right key.

    input.to_string(input.RIGHT)
A simple way of converting inputs into strings.

## Event usage
    event.connect(event_id, func)
You can connect functions to an event system, event_id is simply an integer.

    event.disconnect(event_id,func)
   You can remove a function from the event.

    event.call(event_id, ...)
This is how you call the event, note the ... this means you can put as many params as you want
The only limitation is you cant use tables.

    input.held(input.RIGHT)
Checks if you are holding the right key.

    input.to_string(input.RIGHT)
A simple way of converting inputs into strings.

## Audio usage
    sfx.play("sfx title")
The engine loads all the sound effects in the sfx folder, you can play a sfx simply by typing its name
There is more but I am lazy and I plan on actually reworking the whole audio system, for now you can just play a single sound effect.
