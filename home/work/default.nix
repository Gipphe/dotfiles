{ lib, flags, ... }: lib.optionalAttrs flags.work { imports = [ ./idea.nix ]; }
