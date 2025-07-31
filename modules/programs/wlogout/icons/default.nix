{ pkgs, ... }:
# Icon theme from https://www.gnome-look.org/p/1715570
pkgs.runCommandNoCC "catppuccin-macchiato-icons" { } ''
  ${pkgs.unzip}/bin/unzip -d "$out" "${./Catppuccin-Macchiato.zip}"
''
