{
  config,
  util,
  lib,
  inputs,
  flags,
  ...
}:
util.mkProgram {
  name = "giphtvim";
  options.gipphe.programs.giphtvim.plugins.nixd.docs.options.enable =
    lib.mkEnableOption "documentation for options";
  hm = {
    imports = [ inputs.giphtvim.homeModules.default ];
    config = {
      home.sessionVariables.EDITOR = "nvim";
      programs.fish.shellAbbrs.vim = "nvim";
      nvim = lib.mkMerge [
        {
          enable = true;
        }

        (lib.mkIf flags.isNixOnDroid {
          packageNames = [ "droid" ];
        })

        (lib.mkIf (!flags.isNixOnDroid) {
          packageDefinitions.replace = {
            nvim =
              { pkgs, ... }:
              {
                extra.nixd = lib.mkMerge [
                  {
                    nixpkgs = "import ${pkgs.path} {}";
                  }
                  (lib.mkIf config.gipphe.programs.giphtvim.plugins.nixd.docs.options.enable {

                    home_manager = ''(builtins.getFlake "${inputs.self}").nixosConfigurations.argon.options.home-manager.users.type.getSubOptions []'';
                    nixos_options = ''(builtins.getFlake "${inputs.self}").nixosConfigurations.argon.options'';
                    droid_options = ''(builtins.getFlake "${inputs.self}").nixOnDroidConfigurations.helium.options'';
                  })
                ];
              };
          };
        })
      ];
    };
  };
}
