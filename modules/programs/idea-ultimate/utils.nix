{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.strings) getVersion;
  inherit (lib.versions) majorMinor;
  ideaDir =
    let
      inherit (pkgs.jetbrains.idea-ultimate) name;
      _name = "IntelliJIdea";
      _version = majorMinor (getVersion name);
    in
    "JetBrains/${_name}${_version}";
  linuxConfigDir = ideaDir;
  linuxOptionsDir = "${ideaDir}/options";
in
{
  inherit
    ideaDir
    ;
  linux = {
    optionsDir = linuxOptionsDir;
    configDir = linuxConfigDir;
  };
}
