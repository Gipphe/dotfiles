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
  };
}
