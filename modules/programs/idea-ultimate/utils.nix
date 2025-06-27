{
  lib,
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
    if flags.isNixDarwin then "JetBrains/IntelliJIdea2024.1" else "JetBrains/${_name}${_version}";
  linuxOptionsDir = "JetBrains/${ideaDir}/options";
  darwinOptionsDir = "Library/Application Support/JetBrains/${ideaDir}/options";
in
{
  inherit ideaDir linuxOptionsDir darwinOptionsDir;
}
