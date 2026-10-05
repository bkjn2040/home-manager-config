local keybinds = require("config.keybinds")
local map = vim.keymap.set

map("n", keybinds.window.move_left, "<C-w>h", { desc = "Focus left window" })
map("n", keybinds.window.move_down, "<C-w>j", { desc = "Focus lower window" })
map("n", keybinds.window.move_up, "<C-w>k", { desc = "Focus upper window" })
map("n", keybinds.window.move_right, "<C-w>l", { desc = "Focus right window" })

map("n", "j", "gj", { desc = "Move down by visual line", silent = true })
map("n", "k", "gk", { desc = "Move up by visual line", silent = true })
map("n", "gj", "j", { desc = "Move down by physical line", silent = true })
map("n", "gk", "k", { desc = "Move up by physical line", silent = true })
