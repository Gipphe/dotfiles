{
  inputs,
  lib,
  config,
  ...
}:
{
  config = lib.optionalAttrs config.gipphe.flags.nixos {
    import = [
      inputs.agenix.nixosModules.age
      inputs.catppuccin.nixosModules.catppuccin
      inputs.nh.nixosModules.default

      ./boot
      ./core
      ./desktop
      ./hardware-configuration
      ./nix
      ./secrets
      ./theme
      ./user
      ./virtualbox
      ./wsl
    ];
  };
}
