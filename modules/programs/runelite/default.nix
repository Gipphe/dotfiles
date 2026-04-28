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
    gipphe.programs.hyprland.settings.windowRules = [
      {
        match.float = true;
        match.class = "net-runelite-client-RuneLite";
        match.title = "^(win\\d+)$";
        no_focus = true;
      }
    ];
  };
}
