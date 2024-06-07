{ lib, flags, ... }: lib.optionalAttrs flags.gui { imports = [ ./idea.nix ]; }
