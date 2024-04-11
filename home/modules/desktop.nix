{
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ../../hosts/modules/hyprland/hyprland.conf;
  };
}
