local oil = require("oil")

oil.setup({
  default_file_explorer = true,
  delete_to_trash = true,
  skip_confirm_for_simple_edits = false,
  view_options = {
    show_hidden = true,
  },
  keymaps = {
    ["q"] = "actions.close",
  },
})

vim.keymap.set("n", "-", oil.open, { desc = "Open parent directory" })
vim.keymap.set("n", "<leader>e", function()
  vim.cmd("topleft 32vsplit")
  oil.open(vim.fn.getcwd())
  vim.wo.winfixwidth = true
end, { desc = "Open directory sidebar" })
