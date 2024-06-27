return {
  {
    "aca/marp.nvim",
    init = function()
      vim.api.nvim_create_autocmd("VimLeavePre", {
        group = vim.api.nvim_create_augroup("marp", { clear = true }),
        callback = function()
          require("marp.nvim").ServerStop()
        end,
      })
    end,
    keys = {
      { "<leader>mpo", "<cmd>lua require('marp.nvim').ServerStart()<cr>", desc = "Start Marp server" },
      { "<leader>mpc", "<cmd>lua require('marp.nvim').ServerStop()<cr>",  desc = "Stop Marp server" },
    }
  }
}
