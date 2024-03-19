return {
  {
    "klen/nvim-config-local",
    opts = {
      config_files = { ".nvim.lua", ".nvimrc", ".exrc" },

      hashfile = vim.fn.stdpath("data") .. "/config-local",

      autocommands_create = true,
      commands_create = true,
      silent = false,
      lookup_parents = false,
    }
  }
}
