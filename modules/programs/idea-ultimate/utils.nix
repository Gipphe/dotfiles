{
  lib,
  config,
  flags,
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
    if flags.isNixDarwin then "JetBrains/IntelliJIdea2025.1" else "JetBrains/${_name}${_version}";
  linuxConfigDir = "${config.xdg.configHome}/JetBrains/${ideaDir}";
  linuxOptionsDir = "${ideaDir}/options";
  darwinOptionsDir = "Library/Application Support/${ideaDir}/options";
in
{
  inherit
    ideaDir
    ;
  darwin = {
    optionsDir = darwinOptionsDir;
  };
  linux = {
    optionsDir = linuxOptionsDir;
    configDir = linuxConfigDir;
  };
}
