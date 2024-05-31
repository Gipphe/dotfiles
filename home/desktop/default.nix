{
  inputs,
  lib,
  flags,
  ...
}:
lib.optionalAttrs flags.desktop {
  imports = [
    inputs.hyprlock.homeManagerModules.default
    inputs.hypridle.homeManagerModules.default
    ./rice
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./hyprland.conf;
  };
}
