{
  lib,
  flags,
  inputs,
  ...
}:
lib.optionalAttrs flags.system.isNixDarwin {
  imports = [ inputs.mac-app-util.homeManagerModules.default ];
}
