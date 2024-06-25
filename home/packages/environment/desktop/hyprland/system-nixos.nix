{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
{
  imports = [ ./wayland ];
  config = lib.mkIf config.gipphe.environment.desktop.hyprland.enable {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    };
    # security.pam.services.hyprlock = { };
  };
}
