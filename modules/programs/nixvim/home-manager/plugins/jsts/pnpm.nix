{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "pnpm.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "lukahartwig";
          repo = "pnpm.nvim";
          rev = "d56660857cb34f92887dc3ba37070af1309dc455";
          hash = "sha256-zjZyxEH/4dp58RndNsNG5DtngtHlkWz3Vj88ixx1Wdk=";
        };
      })
    ];
    extraConfigLua = ''
      require('telescope').load_extension('pnpm')
    '';
    plugins.lsp.servers.ts_ls.onAttach.function = ''
      vim.keymap.set("n", "<leader>cw", function()
        require('telescope').extensions.pnpm.workspace()
      end, { buffer = true, desc = "Select pnpm workspace", silent = true })
    '';
  };
}
