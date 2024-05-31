{
  lib,
  flags,
  pkgs,
  ...
}:
lib.optionalAttrs flags.audio {
  imports = [ ./bcn.nix ];
  home.packages = with pkgs; [
    mpc-cli
    cava
  ];
}
