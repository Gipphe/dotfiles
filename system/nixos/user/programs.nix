{ lib, flags, ... }:
lib.optionalAttrs flags.gaming {
  programs.steam = {
    enable = true;
  };
}
