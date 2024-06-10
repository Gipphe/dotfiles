{
  lib,
  pkgs,
  inputs,
  flags,
  ...
}:
{
  config = lib.mkIf (flags.desktop.enable && flags.desktop.hyprland) {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    };
    # security.pam.services.hyprlock = { };
  };
}
