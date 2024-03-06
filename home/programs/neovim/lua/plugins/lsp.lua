return {
  {
    "neovim/nvim-lspconfig",
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "docker-compose-language-service",
        "dockerfile-language-server",
        "eslint-lsp",
        "gradle-language-server",
        "hadolint",
        "json-lsp",
        "lemminx",
        "lua-language-server",
        "markdownlint",
        "marksman",
        "nil",
        "powershell-editor-services",
        "shfmt",
        "stylua",
        "terraform-ls",
        "typescript-language-server",
        "xmlformatter",
        "yaml-language-server",
      },
    },
  },
}
