{ util, pkgs, ... }:
util.mkProgram {
  name = "plymouth";
  system-nixos.boot.plymouth = {
    enable = true;
    theme = "catppuccin-macchiato";
    themePackages = pkgs.catppuccin-plymouth.override { variant = "macchiato"; };
  };
}
