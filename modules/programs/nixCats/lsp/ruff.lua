return {
  on_attach = function(client)
    -- Disable hover in favour of Pyright
    if require('nixCatsUtils').enableForCategory 'basedpyright' then
      client.server_capabilities.hoverProvider = false
    end
    vim.keymap.set('n', '<leader>co', function()
      vim.lsp.buf.code_action {
        apply = true,
        context = {
          only = { 'source.organizeImports' },
          diagnostics = {},
        },
      }
    end, { buffer = true, desc = 'Organize imports', silent = true })
  end,
}
