{
  lib,
  flags,
  pkgs,
  ...
}:
lib.optionalAttrs flags.aux.audio {
  imports = [ ./bcn.nix ];
  home.packages = with pkgs; [
    mpc-cli
    cava
  ];
}
