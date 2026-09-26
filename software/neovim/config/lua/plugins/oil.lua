local oil = require("oil")
local oil_util = require("oil.util")
local keybinds = require("config.keybinds")
local sidebar_width = 32

--[[
-- Helper Functions
--]]

-- Get Oil sidebar
local function get_oil_sidebar()
  local win = vim.g.oil_sidebar

  -- Check if window is a valid sidebar
  if
    type(win) == "number"
    and vim.api.nvim_win_is_valid(win)
    and vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "oil"
  then
    return win
  end

  -- Set sidebar to nil if not a valid sidebar
  vim.g.oil_sidebar = nil
  return vim.g.oil_sidebar
end

-- Pin Oil sidebar to left
local function pin_oil_sidebar()
  -- Get sidebar
  local sidebar = get_oil_sidebar()
  if not sidebar then
    return
  end

  -- Move sidebar window to the left
  vim.api.nvim_win_call(sidebar, function()
    vim.cmd("wincmd H")
  end)
end

-- Get window on the right of sidebar
local function get_window_right_of_sidebar()
  -- Get sidebar
  local sidebar = get_oil_sidebar()
  if not sidebar then
    return
  end

  -- Get window on the right of sidebar
  local target = vim.api.nvim_win_call(sidebar, function()
    vim.cmd("wincmd l")
    return vim.api.nvim_get_current_win()
  end)

  -- Check if sidebar is not equal to target
  if target ~= sidebar then
    return target
  else
    return nil
  end
end

-- Open window in entry
local function open_entry_in_window(target)
  oil.select({
    handle_buffer_callback = function(buf)
      if vim.api.nvim_win_is_valid(target) then
        vim.api.nvim_win_set_buf(target, buf)
      end
    end,
  })
end

-- Select entry
local function select_entry()
  local entry = oil.get_cursor_entry()
  if not entry or oil_util.is_directory(entry) then
    oil.select()
    return
  end

  local current_win = vim.api.nvim_get_current_win()
  if current_win == get_oil_sidebar() then
    local target = get_window_right_of_sidebar()
    if target then
      open_entry_in_window(target)
      return
    end
  end

  oil.select()
end

local function select_in_split()
  local entry = oil.get_cursor_entry()
  if not entry or oil_util.is_directory(entry) then
    oil.select()
    return
  end

  local target = get_window_right_of_sidebar()
  if not target then
    oil.select({ horizontal = true })
    return
  end

  local split = vim.api.nvim_win_call(target, function()
    vim.cmd("split")
    return vim.api.nvim_get_current_win()
  end)

  open_entry_in_window(split)
end

local function open_oil_sidebar(directory)
  vim.cmd("vsplit")
  vim.cmd("wincmd H")

  vim.g.oil_sidebar = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_width(vim.g.oil_sidebar, sidebar_width)
  vim.wo[vim.g.oil_sidebar].winfixwidth = true

  oil.open(directory or vim.fn.getcwd())
end

local function close_oil_sidebar()
  local sidebar = vim.g.oil_sidebar

  if #vim.api.nvim_tabpage_list_wins(vim.api.nvim_win_get_tabpage(sidebar)) == 1 then
    vim.api.nvim_win_call(sidebar, function()
      vim.wo.winfixwidth = false
      oil.close()
    end)
  else
    vim.api.nvim_win_close(sidebar, false)
  end

  vim.g.oil_sidebar = nil
end

local function focus_oil_sidebar()
  local sidebar = get_oil_sidebar()
  if sidebar then
    vim.api.nvim_set_current_win(sidebar)
  else
    open_oil_sidebar()
  end
end

local function toggle_oil_sidebar()
  if get_oil_sidebar() then
    close_oil_sidebar()
  else
    open_oil_sidebar()
  end
end

--[[
-- Oil Setup
--]]
oil.setup({
  default_file_explorer = true,
  delete_to_trash = true,
  skip_confirm_for_simple_edits = false,
  view_options = {
    show_hidden = true,
  },
  keymaps = {
    [keybinds.file_explorer.disabled.parent_directory] = false,
    [keybinds.file_explorer.disabled.select_entry] = false,
    [keybinds.file_explorer.open_entry] = { callback = select_entry, desc = "Open entry" },
    [keybinds.file_explorer.open_entry_in_split] = { callback = select_in_split, desc = "Open in new split" },
    [keybinds.file_explorer.close] = "actions.close",
  },
})

--[[
-- Autocommands
--]]
local oil_sidebar_group = vim.api.nvim_create_augroup("oil_sidebar", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = oil_sidebar_group,
  pattern = "oil",
  callback = function(event)
    if get_oil_sidebar() then
      return
    end

    local sidebar = vim.api.nvim_get_current_win()
    if vim.api.nvim_win_get_buf(sidebar) ~= event.buf then
      sidebar = vim.fn.bufwinid(event.buf)
    end

    if sidebar ~= -1 then
      vim.g.oil_sidebar = sidebar
      vim.schedule(pin_oil_sidebar)
    end
  end,
})

-- Handle sidebar close
vim.api.nvim_create_autocmd("WinClosed", {
  group = oil_sidebar_group,
  callback = function(event)
    if tonumber(event.match) == vim.g.oil_sidebar then
      vim.g.oil_sidebar = nil
    end
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = oil_sidebar_group,
  callback = function(event)
    if vim.api.nvim_get_current_win() == vim.g.oil_sidebar and vim.bo[event.buf].filetype ~= "oil" then
      vim.g.oil_sidebar = nil
    end
  end,
})

vim.api.nvim_create_autocmd("WinNew", {
  group = oil_sidebar_group,
  callback = function()
    vim.schedule(pin_oil_sidebar)
  end,
})

vim.keymap.set("n", keybinds.file_explorer.focus, focus_oil_sidebar, { desc = "Focus file explorer" })
vim.keymap.set("n", keybinds.file_explorer.toggle, toggle_oil_sidebar, { desc = "Toggle directory sidebar" })
