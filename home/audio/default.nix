{ lib, flags, ... }: lib.optionalAttrs flags.audio { imports = [ ./bcn.nix ]; }
