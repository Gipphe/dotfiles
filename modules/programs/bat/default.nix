{
  util,
  lib,
  config,
  ...
}:
util.mkModule {
  shared.imports = [ (util.mkSimpleProgramByName "bat") ];
  hm = lib.mkIf config.gipphe.programs.bat.enable { programs.fish.shellAbbrs.cat = "bat"; };
}
