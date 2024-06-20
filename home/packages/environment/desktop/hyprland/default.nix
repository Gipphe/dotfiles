{
  inputs,
  lib,
  config,
  flags,
  ...
}:
lib.optionalAttrs flags.system.isNixos {
  imports = [
    inputs.hyprlock.homeManagerModules.default
    inputs.hypridle.homeManagerModules.default
    ./rice
  ];
  options.gipphe.environment.desktop.hyprland.enable = lib.mkEnableOption "hyprland";
  config = lib.mkIf config.gipphe.environment.desktop.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = builtins.readFile ./hyprland.conf;
    };
  };
}
