{
  lib,
  flags,
  hostname,
  ...
}:
let
  configs = {
    argon = ./argon.nix;
    cobalt = ./cobalt.nix;
    fluoride = ./fluoride.nix;
    boron = ./boron.nix;
  };
in
{
  imports = lib.optionals (flags.isSystem && flags.isNixos) [
    (configs.${hostname} or (throw "No hardware config found for ${hostname}"))
  ];
}
