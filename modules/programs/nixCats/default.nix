{
  util,
  pkgs,
  inputs,
  flags,
  ...
}:
let
  nixCats = import ./package.nix inputs;
in
util.mkProgram {
  name = "nixCats";
  hm = {
    imports = [ nixCats.homeModules.default ];
    config = {
      home.sessionVariables.EDITOR = "nvim";
      nvim = {
        enable = true;
        packageDefinitions.merge = {
          categories.droid = flags.isNixOnDroid;
          extra.nixd = {
            nixpkgs = ''import ${pkgs.path} {}'';
            nixos_options = ''(builtins.getFlake "${inputs.self}").nixosConfigurations.argon.options'';
            darwin_options = ''(builtins.getFlake "${inputs.self}").darwinConfigurations.silicon.options'';
            droid_options = ''(builtins.getFlake "${inputs.self}").nixOnDroidConfigurations.helium.options'';
          };
        };
      };
    };
  };
}
