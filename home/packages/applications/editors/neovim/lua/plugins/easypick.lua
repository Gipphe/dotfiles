return {
  {
    'axkirillov/easypick.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim'
    },
    lazy = false,
    opts = function(_, opts)
      if opts.pickers == nil then
        opts.pickers = {}
      end
      local easypick = require('easypick')
      table.insert(opts.pickers, {
        name = "jj",
        command = "jj files",
        previewer = easypick.previewers.default()
      })
    end,
    keys = {
      { "<leader>jj", "<cmd>Easypick jj<cr>", desc = "Find files (jj files)" }
    }
  }
}
