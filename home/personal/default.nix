{ lib, flags, ... }:
lib.optionalAttrs flags.use-case.personal {
  imports = [
    ./filen.nix
    ./gaming.nix
  ];
}
