{ pkgs, ... }:
let
  inherit (import ../util.nix) kv;
in
{
  home.packages = [ pkgs.haskellPackages.fourmolu ];
  programs.nixvim = {
    plugins = {
      none-ls = {
        enable = true;
        sources.formatting = {
          black.enable = true;
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
