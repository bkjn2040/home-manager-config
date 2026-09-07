local smart_splits = require("smart-splits")

local hyprland_directions = {
  left = "l",
  down = "d",
  up = "u",
  right = "r",
}

smart_splits.setup({
  at_edge = function(context)
    vim.system({
      "hyprctl",
      "dispatch",
      string.format(
        'hl.dsp.focus({ direction = "%s" })',
        hyprland_directions[context.direction]
      ),
    }, { detach = true })
  end,
  multiplexer_integration = false,
})

vim.keymap.set("n", "<C-h>", smart_splits.move_cursor_left, { desc = "Focus left window" })
vim.keymap.set("n", "<C-j>", smart_splits.move_cursor_down, { desc = "Focus lower window" })
vim.keymap.set("n", "<C-k>", smart_splits.move_cursor_up, { desc = "Focus upper window" })
vim.keymap.set("n", "<C-l>", smart_splits.move_cursor_right, { desc = "Focus right window" })
