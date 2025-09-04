{
  self,
  util,
  inputs,
  flags,
  ...
}:
let
  nixCats = import ./package.nix { inherit self inputs; };
in
util.mkProgram {
  name = "nixCats";
  hm = {
    imports = [ nixCats.homeModules.default ];
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
                home_manager = ''(builtins.getFlake "${inputs.self}").nixosConfigurations.argon.options.home-manager.users.type.getSubOptions []'';
                nixos_options = ''(builtins.getFlake "${inputs.self}").nixosConfigurations.argon.options'';
                darwin_options = ''(builtins.getFlake "${inputs.self}").darwinConfigurations.silicon.options'';
                droid_options = ''(builtins.getFlake "${inputs.self}").nixOnDroidConfigurations.helium.options'';
              };
            };
        };
      };
    };
  };
}
