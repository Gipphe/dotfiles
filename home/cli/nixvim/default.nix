{
  pkgs,
  lib,
  config,
  helpers,
  ...
}:
let
  cfg = config.gipphe.nixvim;
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
    imports = [ ./plugins ];
    programs.nixvim = {
      enable = true;
      colorscheme = "catppuccin";
      colorschemes.catppuccin = {
        enable = true;
        flavour = "mocha";
        showBufferEnd = true;
      };
      autoCmd =
        let
          fileMappings = {
            hurl = [ "*.hurl" ];
            sql = [ "*.sqlx" ];
            terraform = [
              "*.tf"
              "tf"
            ];
          };
          fileTypes = lib.attrsets.mapAttrsToList (ft: pattern: {
            inherit pattern;
            group = "file_mapping";
            callback = helpers.raw ''
              function(event)
                vim.b[event.buf].filetype = ${ft}
              end
            '';
          }) fileMappings;
        in
        [
          {
            event = "FileType";
            group = "nvim-metals";
            pattern = [
              "scala"
              "sbt"
              "java"
            ];
            callback = helpers.raw ''
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
        ]
        ++ fileTypes;
    };
  };
}
