{
  util,
  pkgs,
  lib,
  ...
}:
util.mkProgram {
  name = "plymouth";
  system-nixos.boot.plymouth = {
    enable = true;
    theme = lib.mkForce "catppuccin-macchiato";
    themePackages = lib.mkForce [
      (pkgs.catppuccin-plymouth.override { variant = "macchiato"; })
    ];
  };
}
