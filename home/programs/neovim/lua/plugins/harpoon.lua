return {
  {
    "ThePrimeagen/harpoon",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = true,
    keys = {
      { "<leader>hm", "<cmd>lua require('harpoon.mark').add_file()<cr>",        desc = "Mark file with haproon" },
      { "<leader>hn", "<cmd>lua require('harpoon.ui').nav_next()<cr>",          desc = "Go to next harpoon mark" },
      { "<leader>hp", "<cmd>lua require('harpoon.ui').nav_prev()<cr>",          desc = "Go to previous harpoon mark" },
      { "<leader>ha", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "Show harpoon marks" },
      { "<leader>h1", "<cmd>lua require('harpoon.ui').nav_file(1)<cr>",         desc = "Go to first harpoon mark" },
      { "<leader>h2", "<cmd>lua require('harpoon.ui').nav_file(2)<cr>",         desc = "Go to second harpoon mark" },
      { "<leader>h3", "<cmd>lua require('harpoon.ui').nav_file(3)<cr>",         desc = "Go to third harpoon mark" },
      { "<leader>h4", "<cmd>lua require('harpoon.ui').nav_file(4)<cr>",         desc = "Go to fourth harpoon mark" },
    }
  }
}
