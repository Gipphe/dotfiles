{ config, ... }:
let
  inherit (import ../util.nix) kv;
  helpers = config.lib.nixvim;
in
{
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
        settings = {
          format_on_save = helpers.emptyTable;
          formatters_by_ft = {
            lua = [ "stylua" ];
            fish = [ "fish_indent" ];
            sh = [ "shfmt" ];
            nix = [ "nixfmt" ];
          };
          formatters.injected.options.ignore_errors = true;
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
