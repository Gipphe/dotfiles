{ lib, flags, ... }: lib.optionalAttrs flags.desktop { imports = [ ./hyprland ]; }
