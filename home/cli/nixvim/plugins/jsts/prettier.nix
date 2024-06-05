{ pkgs, ... }:
let
  prettier = [
    [
      "prettierd"
      "prettier"
    ]
  ];
in
{
  home.packages = with pkgs; [ prettierd ];
  programs.nixvim.plugins = {
    none-ls.sources.formatting.prettier = {
      enable = true;
      disableTsServerFormatter = true;
    };
    conform-nvim.formattersByFt = {
      "markdown.mdx" = prettier;
      css = prettier;
      graphql = prettier;
      handlebars = prettier;
      html = prettier;
      javascript = prettier;
      javascriptreact = prettier;
      json = prettier;
      jsonc = prettier;
      less = prettier;
      markdown = prettier;
      scss = prettier;
      typescript = prettier;
      typescriptreact = prettier;
      vue = prettier;
      yaml = prettier;
    };
  };
}
