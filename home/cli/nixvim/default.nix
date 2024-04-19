{ lib, config, ... }:
let
  cfg = config.gipphe.programs.nixvim;
  inherit (config.nixvim) helpers;
in
{
  imports = [
    ./autocommands.nix
    ./colorscheme.nix
    ./keymaps.nix
    ./options.nix
    ./plugins
  ];
  options.gipphe.programs.nixvim = {
    enable = lib.mkEnableOption "nixvim" // {
      default = !config.programs.neovim.enable;
    };
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
