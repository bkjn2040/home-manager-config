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

vim.lsp.enable({
  "bashls",
  "clangd",
  "cmake",
  "lua_ls",
  "metals",
  "nixd",
  "rust_analyzer",
})

require("plugins.oil")
require("plugins.telescope")
