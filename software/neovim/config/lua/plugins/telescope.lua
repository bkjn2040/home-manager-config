local builtin = require("telescope.builtin")
local telescope = require("telescope")
local telescope_config = require("telescope.config")
local actions = require("telescope.actions")

vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", function()
  telescope.extensions.live_grep_args.live_grep_args()
end, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fc", function()
  builtin.live_grep({ glob_pattern = "!{spec,test}" })
end, { desc = "Live Grep Code" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find Help Tags" })
vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Find Symbols" })
vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Find Old Files" })
vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Find Word under Cursor" })
vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Search Git Commits" })
vim.keymap.set("n", "<leader>gb", builtin.git_bcommits, { desc = "Search Git Commits for Buffer" })
vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Find Keymaps" })
vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<CR>", { desc = "Telescope Undo" })
vim.keymap.set("n", "<leader>/", function()
  builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
    layout_config = { width = 0.7 },
  }))
end, { desc = "[/] Fuzzily search in current buffer" })

-- Search hidden files while continuing to exclude Git's internal directory.
local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }
table.insert(vimgrep_arguments, "--hidden")
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

local function select_one_or_multi(prompt_bufnr)
  local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
  local selections = picker:get_multi_selection()

  if vim.tbl_isempty(selections) then
    actions.select_default(prompt_bufnr)
    return
  end

  actions.close(prompt_bufnr)
  for _, selection in pairs(selections) do
    if selection.path then
      vim.cmd.edit(vim.fn.fnameescape(selection.path))
    end
  end
end

telescope.setup({
  defaults = {
    vimgrep_arguments = vimgrep_arguments,
    path_display = { "truncate" },
    mappings = {
      n = {
        ["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
      },
      i = {
        ["<C-j>"] = actions.cycle_history_next,
        ["<C-k>"] = actions.cycle_history_prev,
        ["<CR>"] = select_one_or_multi,
        ["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-D>"] = actions.delete_buffer,
        ["<C-s>"] = actions.cycle_previewers_next,
        ["<C-a>"] = actions.cycle_previewers_prev,
      },
    },
  },
  pickers = {
    find_files = {
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    },
  },
  extensions = {
    undo = {
      use_delta = true,
      use_custom_command = nil,
      side_by_side = false,
      vim_diff_opts = { ctxlen = vim.o.scrolloff },
      entry_format = "state #$ID, $STAT, $TIME",
      mappings = {
        i = {
          ["<C-cr>"] = require("telescope-undo.actions").yank_additions,
          ["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
          ["<cr>"] = require("telescope-undo.actions").restore,
        },
      },
    },
  },
})

telescope.load_extension("fzf")
telescope.load_extension("ui-select")
telescope.load_extension("undo")
telescope.load_extension("live_grep_args")
