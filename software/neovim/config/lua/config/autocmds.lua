local group = vim.api.nvim_create_augroup("user_config", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  desc = "Highlight copied text",
  callback = function()
    vim.highlight.on_yank({ timeout = 150 })
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  desc = "Return to the last edit position",
  callback = function(event)
    local mark = vim.api.nvim_buf_get_mark(event.buf, '\"')
    local line_count = vim.api.nvim_buf_line_count(event.buf)

    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Parsers are installed declaratively by Nix. Retain Vim's normal syntax
-- highlighting as a fallback when a Treesitter parser is unavailable.
vim.cmd("syntax enable")

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  desc = "Enable Treesitter highlighting",
  callback = function(event)
    pcall(vim.treesitter.start, event.buf)
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  desc = "Configure LSP keymaps",
  callback = function(event)
    local map = function(keys, action, description)
      vim.keymap.set("n", keys, action, {
        buffer = event.buf,
        desc = "LSP: " .. description,
      })
    end

    map("gd", vim.lsp.buf.definition, "Go to definition")
    map("gD", vim.lsp.buf.declaration, "Go to declaration")
    map("gr", vim.lsp.buf.references, "List references")
    map("gi", vim.lsp.buf.implementation, "Go to implementation")
    map("K", vim.lsp.buf.hover, "Hover documentation")
    map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("<leader>cf", function()
      vim.lsp.buf.format({ async = true })
    end, "Format buffer")
  end,
})

vim.diagnostic.config({
  severity_sort = true,
  underline = true,
  virtual_text = {
    spacing = 2,
    source = "if_many",
  },
  float = {
    border = "rounded",
    source = true,
  },
})
