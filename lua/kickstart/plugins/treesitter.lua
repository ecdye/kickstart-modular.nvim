return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    config = function()
      local filetypes = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
      require('nvim-treesitter').install(filetypes)
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(event)
          local nvim_treesitter = require 'nvim-treesitter'
          local parsers = require 'nvim-treesitter.parsers'

          if not parsers[event.match] then return end

          local ft = vim.bo[event.buf].ft
          local lang = vim.treesitter.language.get_lang(ft)
          nvim_treesitter.install({ lang }):wait(function(err)
            if err then
              vim.notify('Treesitter install error for ft: ' .. ft .. ' err: ' .. err)
              return
            end

            pcall(vim.treesitter.start, event.buf)
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          end)
        end,
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
