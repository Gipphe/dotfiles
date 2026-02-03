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
      nvim = {
        enable = true;
        packageDefinitions.replace = {
          nvim =
            { pkgs, ... }:
            {
              categories = {
                general = true;
                droid = flags.isNixOnDroid;
                full = !flags.isNixOnDroid;
                haskell = !flags.isNixOnDroid;
                go = false;
                elm = false;
              };
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
      };
    };
  };
}
