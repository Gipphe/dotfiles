{
  util,
  config,
  pkgs,
  ...
}:
let
  file_manager_script = pkgs.writeShellScriptBin "file-manager-script.sh" ''
    ${config.programs.wezterm.package}/bin/wezterm start -- "${config.programs.yazi.package}/bin/yazi"
  '';
in
util.makeToggledModule [ "environment" "desktop" "hyprland" ] {
  name = "filemanager";
  shared.gipphe.programs.yazi.enable = true;
  hm.wayland.windowManager.hyprland.settings.bind = [
    "$mod, E, exec, ${file_manager_script}/bin/file-manager-script.sh"
  ];
}
