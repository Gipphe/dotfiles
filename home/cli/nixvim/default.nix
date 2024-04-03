{ lib, config, ... }:
let
  cfg = config.gipphe.nixvim;
in
{
  imports = [
    ./autocommands.nix
    ./plugins
    ./options.nix
    ./keymaps.nix
    ./colorscheme.nix
  ];
  options.gipphe.nixvim = {
    enable = lib.mkOption {
      default = !config.programs.neovim.enable;
      type = lib.types.bool;
    };

    is_wsl = lib.mkOption {
      default = builtins.getEnv "WSL_INTEROP" != "";
      type = lib.types.bool;
    };
  };
  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
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
