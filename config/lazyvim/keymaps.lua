-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Map F8 to close the current window
vim.api.nvim_set_keymap('n', '<F8>', ':q<CR>', { noremap = true, silent = true })

-- Map F7 to save the current document
vim.api.nvim_set_keymap('n', '<F7>', ':w<CR>', { noremap = true, silent = true })

-- Map F5 to open/close the NeoTree explorer in the current working directory (cwd)
vim.api.nvim_set_keymap('n', '<F5>', '<cmd>Neotree toggle<CR>', { noremap = true, silent = true })
