{ lib, ... }:
let
  inherit (builtins) listToAttrs map;
in
{
  programs.nvf.settings.vim.formatter.conform-nvim = {
    enable = true;
    setupOpts = {
      format_on_save = {
        lsp_format = "fallback";
        timeout_ms = 500;
      };
      formatters_by_ft =
        let
          prettier = {
            "@1" = "prettierd";
            "@2" = "prettier";
            stop_after_first = true;
          };
          prettier_formatted =
            lib.pipe
              [
                "markdown.mdx"
                "graphql"
                "hadlebars"
                "json"
                "jsonc"
                "less"
                "scss"
                "vue"
                "yaml"
              ]
              [
                (map (x: {
                  name = x;
                  value = prettier;
                }))
                listToAttrs
              ];
        in
        {
          fish = [ "fish_indent" ];
          # python = [
          #   "ruff_format"
          #   "ruff_organize_imports"
          # ];
          haskell = [ "fourmolu" ];
          cabal = [ "cabal_fmt" ];
        }
        // prettier_formatted;
      formatters.injected.options.ignore_errors = true;
      format = {
        timeout_ms = 3000;
        async = false;
        quiet = false;
        lsp_fallback = true;
      };
    };
  };
}
