return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
    opts = {
      window = {
        mappings = {
          ["h"] = {
            "toggle_node",
            nowait = true,
          },
        }
      },
      filesystem = {
        group_empty_dirs = true,
      }
    }
  }
}
