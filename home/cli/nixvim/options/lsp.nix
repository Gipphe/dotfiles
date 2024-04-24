{
  programs.nixvim.extraConfigLuaPre = ''
    local Lsp = {}

    ---@param opts? lsp.Client.filter
    function Lsp.get_clients(opts)
      local ret = {} ---@type lsp.Client[]
      if vim.lsp.get_clients then
        ret = vim.lsp.get_clients(opts)
      else
        ---@diagnostic disable-next-line: deprecated
        ret = vim.lsp.get_active_clients(opts)
        if opts and opts.method then
          ---@param client lsp.Client
          ret = vim.tbl_filter(function(client)
            return client.supports_method(opts.method, { bufnr = opts.bufnr })
          end, ret)
        end
      end
      return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
    end
  '';
}
