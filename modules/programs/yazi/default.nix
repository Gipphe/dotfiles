{
  lib,
  util,
  config,
  pkgs,
  ...
}:
let
  file_manager_script = pkgs.writeShellScript "file-manager-script.sh" ''
    ${config.programs.wezterm.package}/bin/wezterm start -- "${config.programs.yazi.package}/bin/yazi"
  '';
in
util.mkProgram {
  name = "yazi";
  options.gipphe.programs.yazi.default = lib.mkEnableOption "yazi as default file manager";
  homeManager = {
    programs.yazi = {
      enable = true;
      shellWrapperName = "y";
    };
    gipphe.core.wm.binds = lib.mkIf config.gipphe.programs.yazi.default [
      {
        mod = "$mod";
        key = "E";
        action.spawn = "${file_manager_script}";
      }
    ];
  };
}
