{ inputs, pkgs, ... }:
let
  inherit (import ../util.nix) k kv;
in
{
  programs.nixvim = {
    plugins = {
      lsp = {
        enable = true;
        servers = {
          bashls.enable = true;
          dockerls.enable = true;
          jsonls.enable = true;
          # Awaiting this PR to hit nixos-unstable: https://github.com/NixOS/nixpkgs/pull/335559
          jsonls.package = inputs.nixpkgs-master.legacyPackages.${pkgs.system}.vscode-langservers-extracted;
          html.enable = true;
          # Awaiting this PR to hit nixos-unstable: https://github.com/NixOS/nixpkgs/pull/335559
          html.package = inputs.nixpkgs-master.legacyPackages.${pkgs.system}.vscode-langservers-extracted;
          # Uses haskell-tools instead
          # hls.enable = true;
          java-language-server.enable = true;
          lemminx.enable = true;
          lua-ls.enable = true;
          marksman.enable = true;
          # metals.enable = true;
          sqls.enable = true;
          terraformls.enable = true;
          yamlls.enable = true;
          yamlls.extraOptions = {
            capabilities.textDocument.foldingRange = {
              dynamicRegistration = false;
              lineFoldingOnly = true;
            };
          };
        };
      };
      lspkind.enable = true;
    };
    keymaps = [
      (k "n" "<leader>cl" "<cmd>LspInfo<cr>" { desc = "Lsp info"; })
      (kv "n" "gd" ''
        function()
          require('telescope.builtin').lsp_definitions({ reuse_win = true })
        end
      '' { desc = "Goto Definition"; })
      (k "n" "gr" "<cmd>Telescope lsp_references<cr>" { desc = "References"; })
      (kv "n" "gD" "vim.lsp.buf.declaration" { desc = "Goto Declaration"; })
      (k "n" "gI" ''
        function()
          require('telescope.builtin').lsp_implementations({ reuse_win = true })
        end
      '' { desc = "Goto Implementation"; })
      (k "n" "gy" ''
        function()
          require('telescope.builtin').lsp_type_definitions({ reuse_win = true })
        end
      '' { desc = "Goto T[y]pe Definition"; })
      (kv "n" "K" "vim.lsp.buf.hover" { desc = "Hover"; })
      (kv "n" "gK" "vim.lsp.buf.signature_help" { desc = "Signature Help"; })
      (kv "i" "<c-k>" "vim.lsp.buf.signature_help" { desc = "Signature Help"; })
      (kv [
        "n"
        "v"
      ] "<leader>ca" "vim.lsp.buf.code_action" { desc = "Code Action"; })
      (kv [
        "n"
        "v"
      ] "<leader>cc" "vim.lsp.codelens.run" { desc = "Run Codelens"; })
      (kv "n" "<leader>cC" "vim.lsp.codelens.refresh" { desc = "Refresh & Display Codelens"; })
      (kv "n" "<leader>cA" ''
        function()
          vim.lsp.buf.code_action({ context = { only = { 'source' }, diagnostics = {} } })
        end
      '' { desc = "Source Action"; })
      (kv "n" "<leader>cr" "vim.lsp.buf.rename" { desc = "Rename"; })
    ];
  };
}
