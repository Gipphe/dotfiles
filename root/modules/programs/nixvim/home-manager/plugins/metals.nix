{ config, pkgs, ... }:
let
  helpers = config.lib.nixvim;
in
{
  home.packages = [ pkgs.metals ];
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      plenary-nvim
      nvim-metals
    ];
    autoGroups = {
      metals = {
        clear = true;
      };
    };
    autoCmd = [
      {
        event = "FileType";
        pattern = [
          "scala"
          "sbt"
          "java"
        ];
        group = "metals";
        callback =
          let
            settings = {
              showImplicitArguments = true;
              excludedPackages = [
                "akka.actor.typed.javads1"
                "com.github.swagger.akka.javads1"
              ];
              metalsBinaryPath = "${pkgs.metals}/bin/metals";
            };
          in
          helpers.mkRaw ''
            function()
              local metals = require('metals')
              local config = metals.bare_config()

              config.find_root_dir_max_project_nesting = 3
              config.settings = ${helpers.toLuaObject settings}

              local gradleScript = os.getenv('GRADLE_SCRIPT')
              if (gradleScript ~= nil) then
                config.settings.gradleScript = gradleScript
              end

              config.init_options.statusBarProvider = 'on'
              config.capabilities = require('cmp_nvim_lsp').default_capabilities()

              metals.initialize_or_attach(config)
            end
          '';
      }
    ];
  };
}
