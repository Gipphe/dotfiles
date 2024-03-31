{ config, ...}: 
let inherit (config.nixvim) helpers;
in
{
  programs.nixvim = {
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
