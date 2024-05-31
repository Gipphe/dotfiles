{ flags, ... }:
{
  imports =
    if flags.desktop then
      [
        ./audio
        ./hyprland
        ./nvidia
        ./plasma
        ./wayland
      ]
    else
      [ ];
}
