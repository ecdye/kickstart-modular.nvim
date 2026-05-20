-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

vim.keymap.set('n', '<leader>ev', ':Vex<Cr>', { desc = 'Open file explorer in vertical split' })
vim.keymap.set('n', '<leader>eh', ':Hex<Cr>', { desc = 'Open file explorer in horizontal split' })
vim.keymap.set('n', '<leader>ee', ':Exp<Cr>', { desc = 'Open file explorer in buffer' })

-- Restore cursor position on file open
vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Restore cursor position on file open',
  group = vim.api.nvim_create_augroup('kickstart-restore-cursor', { clear = true }),
  pattern = '*',
  callback = function()
    local line = vim.fn.line '\'"'
    if line > 1 and line <= vim.fn.line '$' then
      vim.cmd 'normal! g\'"'
    end
  end,
})

-- Remove any trailing whitespace before writing file
vim.api.nvim_create_autocmd('BufWritePre', {
  desc = 'Remove trailing whitespace before writing file',
  pattern = '*',
  callback = function()
    local save_cursor = vim.fn.getpos '.'
    pcall(function()
      vim.cmd [[%s/\s\+$//e]]
    end)
    vim.fn.setpos('.', save_cursor)
  end,
})

-- auto-create missing dirs when saving file
vim.api.nvim_create_autocmd('BufWritePre', {
  desc = 'Auto-create missing dirs when saving a file',
  group = vim.api.nvim_create_augroup('kickstart-auto-create-dir', { clear = true }),
  pattern = '*',
  callback = function()
    local dir = vim.fn.expand '<afile>:p:h'
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, 'p')
    end
  end,
})

-- Iterate over all Lua files in the plugins directory and load them

local plugins_dir = vim.fs.joinpath(vim.fn.stdpath 'config', 'lua', 'custom', 'plugins')
for file_name, type in vim.fs.dir(plugins_dir, { follow = true }) do
  if (type == 'file' or type == 'link') and file_name:match '%.lua$' and file_name ~= 'init.lua' then
    local module = file_name:gsub('%.lua$', '')
    require('custom.plugins.' .. module)
  end
end
