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
    programs.yazi.enable = true;
    wayland.windowManager.hyprland.settings.bind = lib.mkIf cfg.hyprland.enable [
      "$mod, E, exec, ${file_manager_script}/bin/file-manager-script.sh"
    ];
    gipphe.default.filemanager = lib.mkIf cfg.default {
      name = "yazi";
      package = config.programs.yazi.package;
      actions.open = "${config.programs.yazi.package}/bin/yazi";
    };
  };
}
