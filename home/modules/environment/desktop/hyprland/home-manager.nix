{ lib, config, ... }:
{
  imports = [ ./rice ];
  config = lib.mkIf config.gipphe.environment.desktop.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = builtins.readFile ./hyprland.conf;
    };
    programs.hyprlock.enable = true;
    services.hypridle.enable = true;
  };
}
