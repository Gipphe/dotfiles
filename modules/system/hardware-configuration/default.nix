{
  lib,
  flags,
  hostname,
  ...
}:
let
  configs = {
    "trond-arne" = ./trond-arne.nix;
    "Jarle-wsl" = ./Jarle-wsl.nix;
  };
in
{
  imports = lib.optionals flags.isNixos [
    (configs.${hostname} or (throw "No hardware config found for ${hostname}"))
  ];
}
