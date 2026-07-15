# <p align ="center"> Cookie Engine </p>

Cookie engine is a 2D game engine perfect for making pixel art games using lua 5.4, **Cookie** uses Odin lang + raylib to run your games, it is powerful and easy to use, it is made by me Dragon20C.

<p align="center">WARNING</p> 
<p align="center"> Cookie engine is experimental and does and will have bugs and issues. </p>

<p align="center"> This project is licensed under the GNU GPL v3.0. See the LICENSE file for details. </p>

## Installation

Note: the install scripts exists in this repo in installers directory.

## (Linux/MacOS)

Downloading the install script, run these commands in your terminal:

```sh
curl -LO https://raw.githubusercontent.com/Dragon20C/Cookie-Engine/main/installers/install.sh
chmod +x install.sh
./install.sh
```

The installer will:

- Download the latest Cookie Engine release.
- Install it to `~/CookieEngine`.
- Add `COOKIE_ENGINE_ROOT` to your `~/.bashrc`.
- Add Cookie Engine to your `PATH`.



## (Windows)
umm sorry, I have not made one yet...

**Cookie Usage**
Commands
- **new**
 
`cookie new cool_game desired/path`

creates a new project, path is optional it will create it in the current dir.


- **run**

runs the project with debug mode off, cookie.IS_DEV is false.


`cookie run desired/path`
- **dev**

When developing a game dev mode allows you to debug using cookie.IS_DEV which becomes true.


`cookie dev desired/path`
- **export**

`cookie export desired/path`

exports the project to the avaliable oses e.g Linux, Windows, MacOS.


- **version**

`cookie version`

prints the currently installed version of cookie.


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
