{ util, pkgs, ... }:
let
  pkg = pkgs.runelite;
in
# Runelite has some issues with scaling, but setting the following property
# in the currently selected profile under
# ~/.local/share/bold-launcher/.runelite/profiles2 helps:
#
# runelite.clientBounds=0\:37\:1920\:1043\:c
#
# This ensures that the Runelite client itself stretches and scales to the
# window, while keeping the game window within the same rendered pixel size.
# This does however mean that resizing the Runelite client causes the game
# window to stretch, and also causes mouse clicks to become misaligned, but
# that is the price to pay for a game window that scales to the monitor
# resolution.
util.mkGaming {
  name = "runelite";
  homeManager = {
    home = {
      packages = [
        (pkgs.symlinkJoin {
          inherit (pkg) name version;
          paths = [ pkg ];
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/runelite \
              --set GDK_SCALE 2 \
              --set _JAVA_AWT_WM_NONREPARENTING 1
          '';
        })
      ];
    };
    wayland.windowManager.hyprland.settings.window_rule = [
      {
        match.float = true;
        match.class = "net-runelite-client-RuneLite";
        match.title = "^(win\\d+)$";
        no_focus = true;
      }
    ];
  };
}
