local builtin = require("telescope.builtin")
local keybinds = require("config.keybinds")

require("telescope").setup({
  defaults = {
    layout_config = {
      prompt_position = "top",
    },
    sorting_strategy = "ascending",
  },
  pickers = {
    find_files = {
      hidden = true,
    },
  },
})

vim.keymap.set("n", keybinds.file_search.find_files, builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", keybinds.file_search.search_text, builtin.live_grep, { desc = "Search text" })
vim.keymap.set("n", keybinds.file_search.find_buffers, builtin.buffers, { desc = "Find buffers" })
vim.keymap.set("n", keybinds.file_search.find_recent_files, builtin.oldfiles, { desc = "Find recent files" })
vim.keymap.set("n", keybinds.file_search.search_help, builtin.help_tags, { desc = "Search help" })
vim.keymap.set("n", keybinds.file_search.search_current_buffer, builtin.current_buffer_fuzzy_find, {
  desc = "Search current buffer",
})
