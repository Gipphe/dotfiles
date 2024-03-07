{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
      name = "FiraCode Nerd Font Mono";
    };
    settings = {
      scrollback_lines = 4000;
      show_hyperlink_targets = "yes";
      paste_actions = "quote-urls-at-prompt";
      mouse_hide_wait = 3.0;
      strip_trailing_spaces = "smart";
      allow_remote_control = "password";
    };
    theme = "Arthur";
  };
}
