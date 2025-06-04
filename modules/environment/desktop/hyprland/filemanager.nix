{
  lib,
  util,
  config,
  pkgs,
  ...
}:
let
  file_manager_script = pkgs.writeShellScriptBin "file-manager-script.sh" ''
    ${config.programs.wezterm.package}/bin/wezterm start -- ${config.programs.yazi.package}/bin/yazi"
  '';
in
util.mkModule {
  shared.gipphe.programs.yazi.enable =
    lib.mkDefault config.gipphe.environment.desktop.hyprland.enable;
  hm.config = lib.mkIf config.gipphe.environment.desktop.hyprland.enable {
    wayland.windowManager.hyprland.settings.bind = [
      "$mod, E, exec, ${file_manager_script}/bin/file-manager-script.sh" # Opens the file manager
    ];
  };
}
