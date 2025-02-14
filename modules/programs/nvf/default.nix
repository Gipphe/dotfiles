{
  util,
  inputs,
  ...
}:
let
  inherit (builtins) map listToAttrs;
in
util.mkProgram "nvf" {
  hm = {
    imports = [ inputs.nvf.homeManagerModules.default ];
    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          syntaxHighlighting = true;
          theme = {
            name = "catppuccin";
            style = "dark";
          };
          treesitter = {
            enable = true;
            autotagHtml = true;
            context.enable = true;
            fold = true;
            highlight.enable = true;
            incrementalSelection.enable = true;
            indent.enable = true;
            mappings.incrementalSelection = {
              init = "<C-space>";
              incrementByNode = "<C-space>";
              incrementByScope = null;
              decrementByNode = "<bs>";
            };
          };
          ui = {
            breadcrumbs = {
              enable = true;
              navbuddy.enable = true;
            };
            illuminate.enable = true;
            modes-nvim.enable = true;
            noice.enable = true;
            nvim-ufo.enable = true;
          };
          undoFile = {
            enable = true;
          };
          useSystemClipboard = true;
          lsp = {
            enable = true;
            formatOnSave = true;
            lightbulb.enable = true;
            lspSignature.enable = true;
            lspkind.enable = true;
            trouble.enable = true;
            mappings = {
              hover = "K";
            };
          };
          telescope.enable = true;
          binds = {
            whichkey.enable = true;
          };
          mini = {
            ai.enable = true;
            surround.enable = true;
            comment.enable = true;
            notify.enable = true;
            pairs.enable = true;
            sessions.enable = true;
            statusline.enable = true;
            tabline.enable = true;
            trailspace.enable = true;
            visits.enable = true;
          };
          formatter.conform-nvim = {
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
                    [
                      "markdown.mdx"
                      "css"
                      "graphql"
                      "handlebars"
                      "html"
                      "javascript"
                      "javascriptreact"
                      "json"
                      "jsonc"
                      "less"
                      "markdown"
                      "scss"
                      "typescript"
                      "typescriptreact"
                      "vue"
                      "yaml"
                    ]
                    |> map (x: {
                      name = x;
                      value = prettier;
                    })
                    |> listToAttrs;
                in
                {
                  lua = [ "stylua" ];
                  fish = [ "fish_indent" ];
                  sh = [ "shfmt" ];
                  nix = [ "nixfmt" ];
                  python = [
                    "ruff_format"
                    "ruff_organize_imports"
                  ];
                  terraform = [ "terraform_fmt" ];
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
        };
      };
    };
  };
}
