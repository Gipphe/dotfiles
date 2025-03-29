vim.api.nvim_create_user_command('Redir', function(ctx)
  ---@type string|nil
  local output = vim.api.nvim_exec2(ctx.args, { output = true }).output
  local lines = output ~= nil and vim.split(output, '\n', { plain = true })
  vim.cmd 'new'
  if lines ~= false then
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  end
  vim.opt_local.modified = false
end, { nargs = '+', complete = 'command' })
