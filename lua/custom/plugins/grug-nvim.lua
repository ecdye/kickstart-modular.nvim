return {
  'MagicDuck/grug-far.nvim',
  opts = {},
  keys = {
    {
      '<leader>sp',
      function()
        require('grug-far').open()
      end,
      desc = '[S]earch & Re[p]lace (grug-far)',
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
