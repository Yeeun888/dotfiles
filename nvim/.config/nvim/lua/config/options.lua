-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = false -- Disable relative line numbers
-- vim.g.lazyvim_rust_diagnostics = "rust-analyzer"
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250

-- Completion options
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
vim.opt.shortmess = vim.opt.shortmess + { c = true }
