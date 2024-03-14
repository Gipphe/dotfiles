local ht = require('haskell-tools')
local bufnr = vim.api.nvim_get_current_buf()
local def_opts = { noremap = true, silent = true, buffer = bufnr, }
-- haskell-language-server relies heavily on codeLenses,
-- so auto-refresh (see advanced configuration) is enabled by default
vim.keymap.set('n', '<leader>ck', vim.lsp.codelens.run, vim.tbl_extend("force", def_opts, {
  desc = "Run codelens",
}))
vim.keymap.set('n', '<leader>hs', ht.hoogle.hoogle_signature, vim.tbl_extend("force", def_opts, {
  desc = "Hoogle search for the type signature of the definition under the cursor",
}))
vim.keymap.set('n', '<leader>ea', ht.lsp.buf_eval_all, vim.tbl_extend("force", def_opts, {
  desc = "Evaluate all code snippets",
}))
vim.keymap.set('n', '<leader>rr', ht.repl.toggle, vim.tbl_extend("force", def_opts, {
  desc = "Toggle a GHCi repl for the current package",
}))
vim.keymap.set('n', '<leader>rf', function()
  ht.repl.toggle(vim.api.nvim_buf_get_name(0))
end, vim.tbl_extend("force", def_opts, {
  desc = "Toggle a GHCi repl for the current buffer",
}))
vim.keymap.set('n', '<leader>rq', ht.repl.quit, vim.tbl_extend("force", def_opts, {
  desc = "Close repl",
  buffer = bufnr,
}))
