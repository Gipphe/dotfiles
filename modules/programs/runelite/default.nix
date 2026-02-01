{ util, pkgs, ... }:
let
  pkg = pkgs.runelite;
in
util.mkProgram {
  name = "runelite";
  hm = {
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
    wayland.windowManager.hyprland.settings.windowrule = [
      "no_focus true, match:float yes, match:class net-runelite-client-RuneLite, match:title ^(win\d+)$"
    ];
  };
}
