---@meta

---@class Input
--- -- Keyboard
---@field KEY_A integer
---@field KEY_B integer
---@field KEY_C integer
---@field KEY_D integer
---@field KEY_E integer
---@field KEY_F integer
---@field KEY_G integer
---@field KEY_H integer
---@field KEY_I integer
---@field KEY_J integer
---@field KEY_K integer
---@field KEY_L integer
---@field KEY_M integer
---@field KEY_N integer
---@field KEY_O integer
---@field KEY_P integer
---@field KEY_Q integer
---@field KEY_R integer
---@field KEY_S integer
---@field KEY_T integer
---@field KEY_U integer
---@field KEY_V integer
---@field KEY_W integer
---@field KEY_X integer
---@field KEY_Y integer
---@field KEY_Z integer
---@field KEY_0 integer
---@field KEY_1 integer
---@field KEY_2 integer
---@field KEY_3 integer
---@field KEY_4 integer
---@field KEY_5 integer
---@field KEY_6 integer
---@field KEY_7 integer
---@field KEY_8 integer
---@field KEY_9 integer
---@field KEY_ENTER integer
---@field KEY_ESCAPE integer
---@field KEY_SPACE integer
---@field KEY_TAB integer
---@field KEY_BACKSPACE integer
---@field KEY_LEFT integer
---@field KEY_RIGHT integer
---@field KEY_UP integer
---@field KEY_DOWN integer
---@field KEY_LEFT_SHIFT integer
---@field KEY_RIGHT_SHIFT integer
---@field KEY_LEFT_CTRL integer
---@field KEY_RIGHT_CTRL integer
---@field KEY_LEFT_ALT integer
---@field KEY_RIGHT_ALT integer
---@field KEY_INSERT integer
---@field KEY_DELETE integer
---@field KEY_HOME integer
---@field KEY_END integer
---@field KEY_PAGE_UP integer
---@field KEY_PAGE_DOWN integer
---@field KEY_F1 integer
---@field KEY_F2 integer
---@field KEY_F3 integer
---@field KEY_F4 integer
---@field KEY_F5 integer
---@field KEY_F6 integer
---@field KEY_F7 integer
---@field KEY_F8 integer
---@field KEY_F9 integer
---@field KEY_F10 integer
---@field KEY_F11 integer
---@field KEY_F12 integer
--- mouse
---@field MOUSE_LEFT integer
---@field MOUSE_RIGHT integer
---@field MOUSE_MIDDLE integer

---@class Input
input = {}

--- Creates an action to be used as a binding.
---@param action string
---@return string
function input.create_action(action) end

--- Binds an action to a key on the keyboard.
---@param action string
---@param key integer
function input.bind(action, key) end

--- Unbinds an action from a key.
---@param action string
---@param key integer
function input.unbind(action, key) end

--- Checks if an action has been pressed.
---@param action string
---@return boolean
function input.pressed(action) end

--- Checks if an action has been released.
---@param action string
---@return boolean
function input.released(action) end

--- Checks if an action is being held down.
---@param action string
---@return boolean
function input.held(action) end
