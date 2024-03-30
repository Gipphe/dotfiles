{ lib, config, ... }:
let
  cfg = config.gipphe.nixvim;
  inherit (config.nixvim) helpers;
in
{
  imports = [
    ./plugins
    ./options.nix
    ./keymaps.nix
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
      colorscheme = "catppuccin";
      colorschemes.catppuccin = {
        enable = true;
        flavour = "mocha";
        showBufferEnd = true;
      };
      filetype = {
        extension = {
          "hurl" = "hurl";
          "sqlx" = "sql";
          "tf" = "terraform";
        };
      };
      autoCmd = [
        {
          event = "FileType";
          group = "nvim-metals";
          pattern = [
            "scala"
            "sbt"
            "java"
          ];
          callback = helpers.mkRaw ''
            function()
              local metals = require('metals')
              local config = metals.bare_config()
              config.settings = {
                showImplicitArguments = true,
              }
              config.init_options.statusBarProvider = "on"
              metals.initialize_or_attach(config)
            end
          '';
        }
      ];
    };
  };
}
