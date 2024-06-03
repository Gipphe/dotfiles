{ lib, flags, ... }:
lib.optionalAttrs flags.desktop {
  imports = [
    # ./gui-kits.nix
    ./hyprland
    # ./notification.nix
    # ./term.nix
    ./tofi
    ./waybar
    # ./zathura.nix
  ];
}
