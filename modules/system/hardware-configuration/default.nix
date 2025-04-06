{
  lib,
  flags,
  hostname,
  ...
}:
let
  configs = {
    "cobalt" = ./cobalt.nix;
    "argon" = ./argon.nix;
  };
in
{
  imports = lib.optionals (flags.isSystem && flags.isNixos) [
    (configs.${hostname} or (throw "No hardware config found for ${hostname}"))
  ];
}
