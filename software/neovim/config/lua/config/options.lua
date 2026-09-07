local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

opt.splitbelow = true
opt.splitright = true
opt.scrolloff = 8
opt.sidescrolloff = 8

opt.termguicolors = true
opt.title = true
opt.titlestring = "[nvim] %t"
opt.wrap = false
opt.mouse = "a"
opt.clipboard = "unnamedplus"

opt.undofile = true
opt.swapfile = false
opt.updatetime = 250
opt.timeoutlen = 400

vim.g.mapleader = " "
vim.g.maplocalleader = " "
