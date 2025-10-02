{
  self,
  util,
  inputs,
  flags,
  ...
}:
util.mkProgram {
  name = "nixCats";
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
              extra.nixd = {
                nixpkgs = ''import ${pkgs.path} {}'';
                home_manager = ''(builtins.getFlake "${self}").nixosConfigurations.argon.options.home-manager.users.type.getSubOptions []'';
                nixos_options = ''(builtins.getFlake "${self}").nixosConfigurations.argon.options'';
                darwin_options = ''(builtins.getFlake "${self}").darwinConfigurations.silicon.options'';
                droid_options = ''(builtins.getFlake "${self}").nixOnDroidConfigurations.helium.options'';
              };
            };
        };
      };
    };
  };
}
