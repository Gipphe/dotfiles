{
  inputs,
  lib,
  flags,
  ...
}:
lib.optionalAttrs (flags.desktop.enable && flags.desktop.hyprland) {
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
