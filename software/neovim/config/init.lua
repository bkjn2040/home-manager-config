require("config.options")
require("config.keymaps")
require("config.autocmds")

require("tokyonight").setup({
  style = "night",
})
vim.cmd.colorscheme("tokyonight")

local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert(),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
  }, {
    { name = "buffer" },
  }),
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- nvim-lspconfig supplies server definitions; Nix supplies the executables.
vim.lsp.config("*", {
  capabilities = capabilities,
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file("", true),
      },
    },
  },
})

vim.lsp.config("ts_ls", {
  settings = {
    javascript = {
      inlayHints = {
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayParameterNameHints = "literals",
        includeInlayPropertyDeclarationTypeHints = true,
      },
    },
    typescript = {
      inlayHints = {
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayParameterNameHints = "literals",
        includeInlayPropertyDeclarationTypeHints = true,
      },
    },
  },
})

vim.lsp.enable({
  "bashls",
  "clangd",
  "cmake",
  "cssls",
  "eslint",
  "html",
  "jsonls",
  "lua_ls",
  "metals",
  "nixd",
  "rust_analyzer",
  "ts_ls",
})

local conform = require("conform")
local prettier = { "prettier", stop_after_first = true }

conform.setup({
  formatters = {
    -- Node-based formatters can lose piped stdin in some wrapped Neovim
    -- environments. Conform safely writes and reads a temporary file instead.
    prettier = {
      args = { "--write", "$FILENAME" },
      stdin = false,
    },
  },
  formatters_by_ft = {
    css = prettier,
    html = prettier,
    javascript = prettier,
    javascriptreact = prettier,
    json = prettier,
    jsonc = prettier,
    markdown = prettier,
    scss = prettier,
    typescript = prettier,
    typescriptreact = prettier,
    yaml = prettier,
  },
  format_on_save = {
    timeout_ms = 2000,
    lsp_format = "fallback",
  },
})

vim.keymap.set({ "n", "v" }, "<leader>f", function()
  conform.format({
    async = true,
    lsp_format = "fallback",
  })
end, { desc = "Format buffer or selection" })

require("plugins.oil")
require("plugins.telescope")

require("image").setup({
  backend = "kitty",
  integrations = {
    markdown = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = true,
      filetypes = { "markdown", "vimwiki" },
      resolve_image_path = function(document_path, image_path, fallback)
        return fallback(document_path, image_path)
      end,
    },
    html = {
      enabled = false,
    },
    css = {
      enabled = false,
    },
  },
  max_width = nil,
  max_height = nil,
  max_width_window_percentage = nil,
  max_height_window_percentage = 50,
  window_overlap_clear_enabled = false,
  window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
  editor_only_render_when_focused = false,
  tmux_show_only_in_active_window = false,
  hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
})
