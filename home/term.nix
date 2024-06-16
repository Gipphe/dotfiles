{
  lib,
  flags,
  pkgs,
  ...
}:
{
  config = lib.mkIf flags.aux.terminal {
    programs.kitty = {
      enable = true;
      font = lib.mkIf (!flags.stylix.enable) {
        package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
        name = "FiraCode Nerd Font";
      };
      settings = {
        scrollback_lines = 4000;
        show_hyperlink_targets = "yes";
        paste_actions = "quote-urls-at-prompt";
        mouse_hide_wait = 3;
        strip_trailing_spaces = "smart";
        allow_remote_control = "password";
      };
      theme = lib.mkIf (!flags.stylix.enable) "Catppuccin-Macchiato";
    };

    programs.wezterm = {
      enable = true;
      extraConfig = ''
        return {
          hide_tab_bar_if_only_one_tab = true,
          send_composed_key_when_left_alt_is_pressed = true,
          send_composed_key_When_right_alt_is_pressed = false,
          default_cursor_style = 'BlinkingBar',
          -- Disable easing for cursor, blinking text and visual bell
          animation_fps = 1,
        }
      '';
    };

    home.activation."copy-wezterm-config-to-repo" = ''
      dir="$HOME/projects/dotfiles/windows/Config/wezterm/"
      rm -rf "$dir"
      cp -rL "$HOME/.config/wezterm" "$dir"
    '';
  };
}
