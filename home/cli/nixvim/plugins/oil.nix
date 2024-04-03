{ pkgs, ... }:
let
  inherit (import ../util.nix) k;
in
{
  programs.nixvim = {
    plugins.oil = {
      enable = true;
      settings = {
        columns = [
          "icon"
          "size"
        ];
        viewOptions = {
          show_hidden = true;
          is_always_hidden = ''
            function(name)
              return name == ".git" or name == ".jj"
            end
          '';
        };
      };
    };
    keymaps = [ (k "n" "fe" "<cmd>Oil<cr>" { desc = "Open Oil"; }) ];
    extraPlugins = [ pkgs.vimPlugins.nvim-web-devicons ];
  };
}
