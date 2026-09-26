local keybinds = require("config.keybinds")
local map = vim.keymap.set

map("n", keybinds.window.move_left, "<C-w>h", { desc = "Focus left window" })
map("n", keybinds.window.move_down, "<C-w>j", { desc = "Focus lower window" })
map("n", keybinds.window.move_up, "<C-w>k", { desc = "Focus upper window" })
map("n", keybinds.window.move_right, "<C-w>l", { desc = "Focus right window" })
