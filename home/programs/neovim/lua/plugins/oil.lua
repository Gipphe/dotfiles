local Util = require("lazyvim.util")

local dirname = function(path, sep)
  sep = sep or "/"
  return path:match("(.*" .. sep .. ")")
end

return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    opts = {
      default_file_explorer = true,
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name)
          return name == ".git" or name == ".jj"
        end,
      },
    },
    keys = {
      {
        "<leader>fe",
        function()
          local file = vim.api.nvim_buf_get_name(0)
          if not vim.startswith(file, '/') then
            require('oil').open(Util.root())
          end

          local dir = dirname(file)
          require('oil').open(dir)
        end,
        desc = "Explore Oil (parent dir of buffer's file, or root dir)",
      },
      {
        "<leader>fE",
        function()
          require('oil').open(vim.loop.cwd())
        end,
        desc = "Explore Oil (cwd)",
      },
    }
  },
}
