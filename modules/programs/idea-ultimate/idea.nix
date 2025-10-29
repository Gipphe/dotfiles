{
  lib,
  pkgs,
  config,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.idea-ultimate.enable {
    home = {
      packages = [
        pkgs.jetbrains.idea-ultimate
        (pkgs.writeShellScriptBin "idea" ''
          ${pkgs.jetbrains.idea-ultimate}/bin/idea-ultimate "$@" &>/dev/null &
        '')
      ];
    };
  };
}
