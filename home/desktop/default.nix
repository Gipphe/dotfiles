{
  inputs,
  lib,
  flags,
  ...
}:
{
  imports = [
    inputs.hyprlock.homeManagerModules.default
    inputs.hypridle.homeManagerModules.default
  ];
  config = lib.mkIf flags.desktop {
    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = builtins.readFile ./hyprland.conf;
    };
  };
}
