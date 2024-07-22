{
  util,
  lib,
  config,
  ...
}:
{
  imports = [ (util.mkSimpleProgramModule "bat") ];
  config = lib.mkIf (config.gipphe.programs.bat.enable) { programs.fish.shellAbbrs.cat = "bat"; };
}
