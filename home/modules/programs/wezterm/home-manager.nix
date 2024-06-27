{
  lib,
  config,
  utils,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.wezterm.enable {
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
        inherit (utils) mkCopyActivationScript;
        script = mkCopyActivationScript "${config.xdg.configHome}/wezterm" "${config.home.homeDirectory}/projects/dotfiles/windows/Config/wezterm";
      in
      "run ${script}/bin/script";
  };
}
