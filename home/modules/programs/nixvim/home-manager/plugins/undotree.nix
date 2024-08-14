let
  inherit (import ../util.nix) k;
in
{
  programs.nixvim = {
    plugins.undotree.enable = true;
    keymaps = [ (k "n" "<leader>cu" "<cmd>UndotreeToggle<cr>" { desc = "Toggle Undotree"; }) ];
  };
}
