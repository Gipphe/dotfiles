{ lib, flags, ... }:
lib.optionalAttrs flags.use-case.gaming {
  programs.steam = {
    enable = true;
  };
}
