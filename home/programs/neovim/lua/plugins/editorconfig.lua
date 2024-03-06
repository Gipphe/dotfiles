if vim.fn.has("nvim-0.9.0") == 1 then
  return {}
else
  return {
    "gpanders/editorconfig.nvim",
  }
end
