{ util, pkgs, ... }:
util.mkProgram {
  name = "clipboard-jh";
  hm.home = {
    packages = [ pkgs.clipboard-jh ];
    # clipboard-jh spawns a 1x1 window to crab the current clipboard, which
    # causes flickering on Wayland compositors like Hyprland and Niri.
    # CLIPBOARD_NOGUI=1 disables this, which in turn causes it to go out of
    # sync with the system clipboard.
    # See https://github.com/Slackadays/Clipboard/issues/171
    sessionVariables.CLIPBOARD_NOGUI = "1";
  };
}
