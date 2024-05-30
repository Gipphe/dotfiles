{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.machine.desktop {
    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = builtins.readFile ../../hosts/modules/hyprland/hyprland.conf;
    };
  };
}
