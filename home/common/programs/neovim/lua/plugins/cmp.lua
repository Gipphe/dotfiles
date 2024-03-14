return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.completion = opts.completion or {}
      opts.completion.completeopt = table.concat(vim.opt.completeopt:get(), ",")
    end,
  }
}
