-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.shell = "/bin/bash -i"
vim.opt.scrolloff = 8
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"
vim.opt.wrap = true
vim.g.editorconfig = true
vim.opt.title = true
vim.opt.titlestring = [[%t %h%m%r%w (%{v:progname})]]
vim.opt.list = true
vim.opt.conceallevel = 0
vim.opt.listchars = { tab = ">-", trail = "~", extends = ">", precedes = "<" }
vim.opt.completeopt = { "menuone", "preview", "noinsert", "noselect" }

-- Optimal for undotree
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

local is_wsl = os.getenv("WSL_INTEROP") ~= nil

if is_wsl then
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end
