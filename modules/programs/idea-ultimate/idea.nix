{
  lib,
  pkgs,
  config,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.idea-ultimate.enable {
    home = {
      packages = with pkgs; [
        jetbrains.idea-ultimate
        (writeShellScriptBin "idea" ''
          ${pkgs.jetbrains.idea-ultimate}/bin/idea-ultimate "$@" &>/dev/null &
        '')
      ];
    };
  };
}
