{
  inputs,
  lib,
  config,
  ...
}:
let
  cfg = config.gipphe.programs.nixvim;
  inherit (config.nixvim) helpers;
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
  options.gipphe.programs.nixvim = {
    enable = lib.mkEnableOption "nixvim";
  };
  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      extraConfigLuaPre = "local icons = ${helpers.toLuaObject (import ./icons.nix)}";
      filetype = {
        extension = {
          "hurl" = "hurl";
          "sqlx" = "sql";
          "tf" = "terraform";
        };
      };
    };
  };
}
