{ pkgs, ... }:
let
  inherit (import ../../util.nix) k;
in
{
  programs.nixvim = {
    plugins = {
      conform-nvim.settings.formatters_by_ft.python = [
        "ruff_format"
        "ruff_organize_imports"
      ];

      lsp.servers = {
        pyright.enable = true;
        ruff_lsp = {
          enable = true;
          onAttach.function = # lua
            ''
              -- Disable hover in favour of Pyright
              client.server_capabilities.hoverProvider = false

              vim.keymap.set("n", "<leader>co", function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.organizeImports" },
                    diagnostics = {},
                  },
                })
              end, {buffer = true, desc = "Organize Imports", silent = true})
            '';
        };
      };
    };
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "venv-selector.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "linux-cultist";
          repo = "venv-selector.nvim";
          rev = "3c57922256e7e26205a25f5a42ecf7104d9f2c78";
          hash = "sha256-6VQVfoFZazBBTcIjVT8MrL/jdZHE45Z7tFYb0ZH7Xlo=";
        };
      })
    ];
    extraConfigLua = ''
      require('venv-selector').setup({
        name = {
          "venv",
          ".venv",
          "env",
          ".env",
        },
      })
    '';
    keymaps = [
      (k "n" "<leader>cv" "<cmd>VenvSelect<cr>" { desc = "Select VirtualEnv"; })
      (k "n" "<leader>cV" "<cmd>VenvSelectCached<cr>" { desc = "Select cached VirtualEnv"; })
    ];
  };
}
