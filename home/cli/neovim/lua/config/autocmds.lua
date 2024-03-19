-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local mk_augroup = function(name)
  return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end
local metals = require("metals")

local config = metals.bare_config()
config.settings = {
  showImplicitArguments = true,
}
config.init_options.statusBarProvider = "on"

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt", "java" },
  callback = function()
    metals.initialize_or_attach(config)
  end,
  group = mk_augroup("nvim-metals"),
})

local function set_file_type(patterns, filetype)
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = patterns,
    group = mk_augroup(filetype),
    callback = function(event)
      vim.b[event.buf].filetype = filetype
    end,
  })
end

local filemappings = {
  { { '*.hurl' },     'hurl' },
  { { '*.sqlx' },     'sql' },
  { { '*.tf', 'tf' }, 'terraform' },
}

for _, v in pairs(filemappings) do
  set_file_type(v[1], v[2])
end
