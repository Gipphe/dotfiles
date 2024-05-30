{
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [
    inputs.hyprlock.homeManagerModules.default
    inputs.hypridle.homeManagerModules.default
  ];
  config = lib.mkIf config.gipphe.flags.desktop {
    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = builtins.readFile ./hyprland.conf;
    };
  };
}
