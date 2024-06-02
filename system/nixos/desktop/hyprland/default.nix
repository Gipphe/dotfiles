{
  lib,
  pkgs,
  inputs,
  flags,
  ...
}:
{
  config = lib.mkIf flags.hyprland {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    };
    # security.pam.services.hyprlock = { };
  };
}
