{
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
  homeManager = {
    programs.yazi = {
      enable = true;
      shellWrapperName = "y";
    };
    gipphe.core.wm.binds = [
      {
        mod = "$mod";
        key = "E";
        action.spawn = "${file_manager_script}";
      }
    ];
  };
}
