{
  self,
  config,
  util,
  lib,
  inputs,
  flags,
  ...
}:
util.mkProgram {
  name = "nixCats";
  options.gipphe.programs.nixCats.plugins.nixd.docs.options.enable =
    lib.mkEnableOption "documentation for options";
  hm = {
    imports = [ inputs.nixCats-nvim.homeModules.default ];
    config = {
      home.sessionVariables.EDITOR = "nvim";
      programs.fish.shellAbbrs.vim = "nvim";
      nvim = {
        enable = true;
        packageDefinitions.replace = {
          nvim =
            { pkgs, ... }:
            {
              categories = {
                droid = flags.isNixOnDroid;
                full = !flags.isNixOnDroid;
                haskell = !flags.isNixOnDroid;
              };
              extra.nixd = lib.mkMerge [
                {
                  nixpkgs = ''import ${pkgs.path} {}'';
                }
                (lib.mkIf (config.gipphe.programs.nixCats.plugins.nixd.docs.options.enable) {
                  home_manager = ''(builtins.getFlake "${self}").nixosConfigurations.argon.options.home-manager.users.type.getSubOptions []'';
                  nixos_options = ''(builtins.getFlake "${self}").nixosConfigurations.argon.options'';
                  droid_options = ''(builtins.getFlake "${self}").nixOnDroidConfigurations.helium.options'';
                })
              ];
            };
        };
      };
    };
  };
}
