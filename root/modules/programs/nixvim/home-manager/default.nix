{
  inputs,
  lib,
  config,
  ...
}:
let
  cfg = config.gipphe.programs.nixvim;
  helpers = config.lib.nixvim;
in
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./autocommands.nix
    ./colorscheme.nix
    ./keymaps.nix
    ./options
    ./plugins
  ];
  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      extraConfigLuaPre = "local icons = ${helpers.toLuaObject (import ./icons.nix)}";
      filetype = {
        extension = {
          "hurl" = "hurl";
          "tf" = "terraform";
        };
      };
    };
  };
}
