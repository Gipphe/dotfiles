{ pkgs, ... }:
let
  inherit (import ../util.nix) kv;
in
{
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "multicursor.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "jake-stewart";
          repo = "multicursor.nvim";
          rev = "3198bc4b4fb24f63ddc8635f2d40270509b890bf";
          hash = "sha256-t7fny7ODp2jHMh6l0ydZ8svR4XnjS70gWOVXZDwzWrk=";
        };
      })
    ];
    extraConfigLua = ''
      require('multicursor-nvim').setup()
    '';
    keymaps = [
      (kv
        [
          "n"
          "v"
        ]
        "<c-leftmouse>"
        "require('multicursor-nvim').handleMouse"
        {
          desc = "Add cursor with mouse";
        }
      )
    ];
  };
}
