{
  lib,
  config,
  util,
  inputs,
  pkgs,
  ...
}:
let
  inherit (builtins) map listToAttrs;
in
util.mkProgram {
  name = "nvf";
  hm = {
    imports = [ inputs.nvf.homeManagerModules.default ];
    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          syntaxHighlighting = true;
          theme = {
            enable = true;
            name = "catppuccin";
            style = "macchiato";
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
            modes-nvim.setupOpts.line_opacity.visual = 0.5;
            noice.enable = true;
            nvim-ufo.enable = true;
          };
          undoFile = {
            enable = true;
          };
          useSystemClipboard = true;
          autocomplete.nvim-cmp = {
            enable = true;
          };
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
            cheatsheet.enable = true;
            whichKey.enable = true;
          };
          extraPlugins = {
            "oil-nvim" = {
              package = pkgs.vimPlugins.oil-nvim;
              setup = # lua
                ''
                  local oil_always_hidden_names = {
                    [".git"] = true,
                    [".jj"] = true,
                    [".direnv"] = true,
                    [".DS_Store"] = true,
                  }
                  require('oil').setup({
                    columns = { "icon" },
                    keymaps = {
                      ["<C-h>"] = false,
                      ["<C-l>"] = false,
                      ["<C-n>"] = "actions.select_split",
                      ["<C-m>"] = "actions.refresh",
                    },
                    view_options = {
                      show_hidden = true,
                      is_always_hidden = function(name)
                        return oil_always_hidden_names[name] ~= nil
                      end,
                    },
                  })
                '';
            };
          };
          maps.normal = {
            "<leader>e" = {
              action = "<cmd>Oil<cr>";
              desc = "Open Oil (parent dir)";
            };
            "<leader>E" = {
              action = "<cmd>Oil .<cr>";
              desc = "Open Oil (cwd)";
            };
            "<leader>qq" = {
              action = "<cmd>quitall<cr>";
              desc = "Exit";
            };
          };
          languages = {
            enableDAP = true;
            enableExtraDiagnostics = true;
            enableFormat = true;
            enableLSP = true;
            enableTreesitter = true;

            bash.enable = true;
            csharp.enable = true;
            css.enable = true;
            css.format.type = "prettierd";
            go.enable = true;
            haskell.enable = true;
            hcl.enable = true;
            html.enable = true;
            java.enable = true;
            lua.enable = true;
            markdown.enable = true;
            markdown.format.type = "prettierd";
            nix = {
              enable = true;
              format.type = "nixfmt";
              lsp.options = {
                nixpkgs.expr = "import <nixpkgs> { }";
                options.nixos.expr =
                  let
                    configType = if pkgs.stdenv.isDarwin then "darwinConfigurations" else "nixosConfigurations";
                  in
                  "(builtins.getFlake \"${config.home.sessionVariables.FLAKE}\").${configType}.${config.gipphe.hostName}.options";
              };
            };
            python.enable = true;
            python.format.type = "ruff";
            rust.enable = true;
            scala.enable = true;
            sql.enable = true;
            tailwind.enable = true;
            terraform.enable = true;
            ts.enable = true;
            ts.extensions.ts-error-translator.enable = true;
            ts.format.type = "prettierd";
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
                      "graphql"
                      "handlebars"
                      "json"
                      "jsonc"
                      "less"
                      "scss"
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
        };
      };
    };
  };
}
