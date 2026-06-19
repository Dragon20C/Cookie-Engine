# <p align ="center"> Cookie Engine </p>

Cookie engine is a 2D game engine perfect for making pixel art games using lua 5.4, **Cookie** uses Odin lang + raylib to run your games, it is powerful and easy to use, it is made by me Dragon20C.

<p align="center">WARNING</p> 
<p align="center"> Cookie engine is experimental and does and will have bugs and issues. </p>

# Building

Currently Cookie Engine requires you build the project, in the future there is plans on making it easier to install but for now the only option is to build the project.

**Requirements**

 1. Odin -> Dev 2026-05 https://github.com/odin-lang/Odin/releases **Note :** havent tested newer versions
 2. Lua -> 5.4 **Note :** Newer versions might work but Cookie engine is targeted at 5.4 so avoid using newer vers
 3. IDE -> I recommend using **Zed Editor** as it gives you loads of functionality and its really easy to use

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

    gfx.clear(gfx.COLOR_MINT)
Clears the screen with the selected color **mint**
There is in total 16 colors avaliable to you, you can see the options in meta/cookie_gfx.lua.

    gfx.rect(X, Y, Width, Height, Color)
   Creates a unfilled rectangle onto the screen

    gfx.rect_fill(X, Y, Width, Height, Color)
Similar to rect except the whole rectangle is filled with the selected color

    gfx.text(text, x, y, size, Color)
Draws text onto the screen at x and y positions with size and color.

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
