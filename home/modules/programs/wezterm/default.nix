{
  lib,
  config,
  util,
  pkgs,
  ...
}:
util.mkModule {
  options.gipphe.programs.wezterm.enable = lib.mkEnableOption "wezterm";
  hm = lib.mkIf config.gipphe.programs.wezterm.enable {
    programs.wezterm = {
      enable = true;
      extraConfig = ''
        return {
          hide_tab_bar_if_only_one_tab = true,
          send_composed_key_when_left_alt_is_pressed = true,
          send_composed_key_when_right_alt_is_pressed = false,
          default_cursor_style = 'BlinkingBar',
          -- Disable easing for cursor, blinking text and visual bell
          animation_fps = 1,
        }
      '';
    };

    home.activation."copy-wezterm-config-to-repo" =
      let
        inherit (util) copyFileFixingPaths mkCopyActivationScript;
        fromDir = "${config.xdg.configHome}/wezterm";
        toDir = "${config.home.homeDirectory}/projects/dotfiles/windows/Config/wezterm";
        cfg =
          copyFileFixingPaths "fix-wezterm-config-paths" "${fromDir}/wezterm.lua"
            "${toDir}/wezterm.lua";
        dir = mkCopyActivationScript "copy-wezterm-config-dir" fromDir toDir;
        script = pkgs.writeShellApplication {
          name = "copy-wezterm-config";
          runtimeInputs = [
            cfg
            dir
          ];
          text = ''
            copy-wezterm-config-dir
            fix-wezterm-config-paths
          '';
        };
      in
      "run ${script}/bin/copy-wezterm-config";
  };
}
