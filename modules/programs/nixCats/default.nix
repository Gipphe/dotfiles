{
  util,
  pkgs,
  inputs,
  flags,
  ...
}:
util.mkProgram {
  name = "nixCats";
  hm = {
    imports = [ inputs.nixCats.homeModules.default ];
    config.nvim = {
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
}
