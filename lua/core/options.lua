-- Global Neovim options

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Line wrapping
vim.opt.wrap = false

-- Backup and swap files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Colors
vim.opt.termguicolors = true

-- Scrolling and cursor
vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- Performance
vim.opt.updatetime = 50

-- Shada file settings
vim.opt.shada = "!,'1000,<50,s10,h"
vim.opt.shadafile = vim.fn.stdpath('state') .. '/shada/main.shada'

-- Disable editorconfig
vim.g.editorconfig = false

-- Set Python host prog if defined in environment
if os.getenv("NVIM_PYTHON3_HOST_PROG") then
  vim.g.python3_host_prog = os.getenv("NVIM_PYTHON3_HOST_PROG")
end

-- Enable diagnostics in insert mode
vim.diagnostic.config({
  update_in_insert = true,
})

-- Enable 24bit colours
vim.opt.termguicolors = true
