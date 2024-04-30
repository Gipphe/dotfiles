{ pkgs, ... }:
let
  inherit (import ../util.nix) kv;
  prettier = [
    [
      "prettierd"
      "prettier"
    ]
  ];
in
{
  home.packages = [ pkgs.haskellPackages.fourmolu ];
  programs.nixvim = {
    plugins = {
      none-ls = {
        enable = true;
        sources.formatting = {
          black.enable = true;
          prettier = {
            enable = true;
            disableTsServerFormatter = true;
          };
          shfmt.enable = true;
          stylua.enable = true;
        };
      };
      conform-nvim = {
        enable = true;
        formatOnSave = { };
        formattersByFt = {
          lua = [ "stylua" ];
          fish = [ "fish_indent" ];
          sh = [ "shfmt" ];
          nix = [ "nixfmt" ];
          haskell = [ "fourmolu" ];
          python = [ "black" ];
          javascript = prettier;
          javascriptreact = prettier;
          typescript = prettier;
          typescriptreact = prettier;
          vue = prettier;
          css = prettier;
          scss = prettier;
          less = prettier;
          html = prettier;
          json = prettier;
          jsonc = prettier;
          yaml = prettier;
          markdown = prettier;
          "markdown.mdx" = prettier;
          graphql = prettier;
          handlebars = prettier;
        };
        formatters = {
          injected.options.ignore_errors = true;
        };
        extraOptions = {
          format = {
            timeout_ms = 3000;
            async = false;
            quiet = false;
            lsp_fallback = true;
          };
        };
      };
    };
    keymaps = [
      (kv
        [
          "n"
          "v"
        ]
        "<leader>cF"
        "function() require('conform').format({ formatters = {'injected'}, timeout_ms = 3000 }) end"
        { desc = "Format injected langs"; }
      )
    ];
  };
}
