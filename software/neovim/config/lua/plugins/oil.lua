local oil = require("oil")

oil.setup({
  default_file_explorer = true,
  delete_to_trash = true,
  skip_confirm_for_simple_edits = false,
  view_options = {
    show_hidden = true,
  },
  keymaps = {
    ["<C-h>"] = false,
    ["<C-l>"] = false,
    ["q"] = "actions.close",
  },
})

vim.keymap.set("n", "-", oil.open, { desc = "Open parent directory" })
vim.keymap.set("n", "<leader>e", function()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "oil" then
      vim.api.nvim_win_close(win, false)
      return
    end
  end

  vim.cmd("topleft 32vsplit")
  oil.open(vim.fn.getcwd())
  vim.wo.winfixwidth = true
end, { desc = "Toggle directory sidebar" })
