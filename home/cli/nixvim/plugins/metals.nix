{ config, pkgs, ... }:
let
  inherit (config.nixvim) helpers;
in
{
  home.packages = [ pkgs.metals ];
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      plenary-nvim
      nvim-metals
    ];
    extraConfigLua = ''
      local setup_nvim_metals = function()
        local metals = require('metals')
        local config = metals.bare_config()
        local gradleScript = os.getenv('GRADLE_SCRIPT')
        config.find_root_dir_max_project_nesting = 3
        config.settings = {
          showImplicitArguments = true,
          excludedPackages = { "akka.actor.typed.javads1", "com.github.swagger.akka.javads1" },
          metalsBinaryPath = "${pkgs.metals}/bin/metals",
        }
        if (gradleScript ~= nil) then
          config.settings.gradleScript = gradleScript
        end

        config.init_options.statusBarProvider = 'on'
        config.capabilities = require('cmp_nvim_lsp').default_capabilities()
        metals.setup(config)
      end
    '';
    autoGroups = {
      nvim-metals = {
        clear = true;
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
}
