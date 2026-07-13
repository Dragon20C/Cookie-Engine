---@meta

gfx            = {}

gfx.BLACK      = 0  --- #000000
gfx.CLAY       = 1  --- #BA6B4A
gfx.CORAL      = 2  --- #F47F57
gfx.ORANGE     = 3  --- #FF8A35
gfx.SAND       = 4  --- #ECC895
gfx.HONEY      = 5  --- #FFE57D
gfx.IVORY      = 6  --- #FDFDFC
gfx.OLIVE      = 7  --- #BAC867
gfx.MINT       = 8  --- #98DBBE
gfx.JADE       = 9  --- #0D9B76
gfx.NAVY       = 10 --- #164475
gfx.AZURE      = 11 --- #1673FF
gfx.AMETHYST   = 12 --- #9872AF
gfx.CANDY      = 13 --- #FFB1CB
gfx.WATERMELON = 14 --- #FE3648
gfx.ROSE       = 15 --- #DA4D52

---Clears the screen with the specified color.
---@param color integer The color to clear the screen with. Use one of the predefined colors in gfx.
function gfx.clear(color) end

--- Draws a rectangle on the screen.
---@param x number The x-coordinate of the rectangle's top-left corner.
---@param y number The y-coordinate of the rectangle's top-left corner.
---@param width number The width of the rectangle.
---@param height number The height of the rectangle.
---@param color integer The color of the rectangle. Use one of the predefined colors in gfx.
function gfx.rectangle(x, y, width, height, color) end

--- Draws a circle on the screen.
---@param x number The x-coordinate of the circle's center.
---@param y number The y-coordinate of the circle's center.
---@param radius number The radius of the circle.
---@param color integer The color of the circle. Use one of the predefined colors in gfx.
function gfx.circle(x, y, radius, color) end

--- Draws a line on the screen.
---@param x1 number The x-coordinate of the starting point of the line.
---@param y1 number The y-coordinate of the starting point of the line.
---@param x2 number The x-coordinate of the ending point of the line.
---@param y2 number The y-coordinate of the ending point of the line.
---@param color integer The color of the line. Use one of the predefined colors in gfx.
function gfx.line(x1, y1, x2, y2, color) end

--- Draws text on the screen.
--- @param text string The text to draw.
--- @param x number The x-coordinate to draw the text at.
--- @param y number The y-coordinate to draw the text at.
--- @param size number The size of the text.
--- @param color integer The color of the text.
function gfx.text(text, x, y, size, color) end

--- Loads a sprite sheet from the specified path.
--- @param cell_width number The width of each sprite in the sheet.
--- @param cell_height number The height of each sprite in the sheet.
--- @param path string The path to the sprite sheet image file.
--- @return integer The loaded sprite sheet.
function gfx.load_sheet(cell_width, cell_height, path) end

--- Unloads a previously loaded sprite sheet.
--- @param sheet integer The sprite sheet to unload.
function gfx.unload_sheet(sheet) end

--- Draws a sprite from the specified sprite sheet at the given position.
--- @param sheet integer The sprite sheet to draw from.
--- @param frame_id integer The index of the sprite frame to draw.
--- @param x number The x-coordinate to draw the sprite at.
--- @param y number The y-coordinate to draw the sprite at.
--- @param flip? boolean Flips the sprite.
function gfx.sprite(sheet, frame_id, x, y, flip) end
