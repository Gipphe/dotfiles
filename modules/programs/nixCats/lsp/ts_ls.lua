return {
  on_attach = function()
    vim.keymap.set('n', '<leader>cw', require('pickers').pnpm_workspaces, { buffer = true, desc = 'Select pnpm workspace', silent = true })
  end,
}
