{
  lib,
  flags,
  inputs,
  ...
}:
lib.optionalAttrs flags.isNixDarwin {
  imports = [ inputs.mac-app-util.homeManagerModules.default ];
}
