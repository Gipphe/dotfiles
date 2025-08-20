return {
  on_attach = function()
    vim.keymap.set('n', '<leader>cw', function()
      require('telescope').extensions.pnpm.workspace()
    end, { buffer = true, desc = 'Select pnpm workspace', silent = true })
  end,
}
