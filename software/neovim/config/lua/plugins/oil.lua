local oil = require("oil")
local oil_util = require("oil.util")
local sidebar_width = 32

local function select_in_target_window()
  -- Check if selected is directoryj
  local entry = oil.get_cursor_entry()
  if not entry or oil_util.is_directory(entry) then
    oil.select()
    return
  end

  -- Get window with Oil open
  local oil_win = vim.api.nvim_get_current_win()
  -- Get window where file is being opened
  local target_win = vim.w[oil_win].oil_target_win

  -- Select target window
  if
    not target_win
    or not vim.api.nvim_win_is_valid(target_win)
    or vim.api.nvim_win_get_tabpage(target_win) ~= vim.api.nvim_get_current_tabpage()
  then
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local buf = vim.api.nvim_win_get_buf(win)
      if win ~= oil_win and vim.bo[buf].filetype ~= "oil" then
        target_win = win
        break
      end
    end
  end

  -- Vertical split if no valid taget window is found
  if not target_win or not vim.api.nvim_win_is_valid(target_win) then
    vim.cmd("rightbelow vsplit")
    target_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_width(oil_win, sidebar_width)
    vim.wo[oil_win].winfixwidth = true
    vim.api.nvim_set_current_win(oil_win)
    vim.w[oil_win].oil_target_win = target_win
  end

  -- Set file buffer as window
  oil.select({
    handle_buffer_callback = function(buf)
      vim.api.nvim_win_set_buf(target_win, buf)
      vim.api.nvim_set_current_win(target_win)
    end,
  })
end

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
    ["<CR>"] = { callback = select_in_target_window, desc = "Open in target window" },
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

  local target_win = vim.api.nvim_get_current_win()
  vim.cmd("topleft " .. sidebar_width .. "vsplit")
  oil.open(vim.fn.getcwd())
  vim.w.oil_target_win = target_win
  vim.wo.winfixwidth = true
end, { desc = "Toggle directory sidebar" })
