{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.flags.gui {
    imports = [
      ./audio
      ./hyprland
      ./nvidia
      ./plasma
      ./wayland
    ];
  };
}
