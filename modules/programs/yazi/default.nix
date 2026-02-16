{
  lib,
  util,
  config,
  pkgs,
  ...
}:
let
  cfg = config.gipphe.programs.yazi;
  file_manager_script = pkgs.writeShellScriptBin "file-manager-script.sh" ''
    ${config.programs.wezterm.package}/bin/wezterm start -- "${config.programs.yazi.package}/bin/yazi"
  '';
in
util.mkProgram {
  name = "yazi";
  options.gipphe.programs.yazi = {
    hyprland.enable = lib.mkEnableOption "hyprland integration" // {
      default = config.programs.hyprland.enable;
      defaultText = "config.programs.hyprland.enable";
    };
    default.enable = lib.mkEnableOption "default file manager" // {
      default = true;
    };
  };
  hm = {
    programs.yazi = {
      enable = true;
      shellWrapperName = "y";
    };
    gipphe.core.wm.binds = lib.mkIf cfg.hyprland.enable [
      {
        mod = "$mod";
        key = "E";
        action.spawn = "${file_manager_script}/bin/file-manager-script.sh";
      }
    ];
  };
}
