{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.nixvim.plugins.spectre;
  inherit (config.nixvim) helpers;
in
{
  options.programs.nixvim.plugins.spectre = {
    enable = lib.mkEnableOption "spectre";
    options = lib.mkOption {
      type = lib.types.submodule;
      default = { };
    };
  };
  config = lib.mkIf cfg.enable ({
    programs.nixvim =
      let
        opts = helpers.toLuaObject cfg.options;
      in
      {
        extraPlugins = [ pkgs.vimPlugins.nvim-spectre ];
        extraConfigLua = "require('spectre').setup(${opts})";
      };
  });
}
