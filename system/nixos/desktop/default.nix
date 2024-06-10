{ lib, flags, ... }:
lib.optionalAttrs flags.desktop.enable {
  imports = [
    ./audio.nix
    ./appimage.nix
    ./hyprland.nix
    ./nvidia.nix
    ./plasma.nix
    ./screen
    ./wayland
  ];
}
