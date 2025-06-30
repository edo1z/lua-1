-- Test configuration for Neovim plugin development

---@diagnostic disable-next-line: undefined-global
local vim = vim

-- Set leader key
vim.g.mapleader = ' '

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- Load the hoge plugin
local ok, hoge = pcall(require, 'hoge')
if ok then
  hoge.setup()
  print("Hoge plugin loaded successfully!")
else
  print("Failed to load hoge plugin:", hoge)
end

-- Helpful keymaps for testing
vim.keymap.set('n', '<leader>r', ':luafile %<CR>', { desc = 'Reload current lua file' })
vim.keymap.set('n', '<leader>q', ':qa!<CR>', { desc = 'Quit Neovim' })
