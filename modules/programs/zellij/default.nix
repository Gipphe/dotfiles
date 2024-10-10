{
  lib,
  util,
  config,
  ...
}:
let
  inherit (import ./helpers.nix { inherit lib; })
    section
    unbind
    shared_except
    bind
    ;
in
util.mkProgram {
  name = "zellij";

  hm = {
    imports = [ ./plugins ];
    xdg.configFile = {
      "zellij/layouts".source = ./layouts;
    };
    programs = {
      zellij = {
        enable = true;

        settings = {
          copy_on_select = true;
          ui.pane_frames.rounded_corners = false;
          keybinds = lib.mergeAttrsList [
            (section "move" (bind "Ctrl e" { SwitchToMode = "Normal"; }))
            (unbind "Ctrl q")
            (unbind "Ctrl o")
            (shared_except [
              "move"
              "locked"
            ] (bind "Ctrl e" { SwitchToMode = "Move"; }))
            (section "session" (bind "Ctrl x" { SwitchToMode = "Normal"; }))
            (shared_except [
              "session"
              "locked"
            ] (bind "Ctrl x" { SwitchToMode = "Session"; }))
            (shared_except [ "locked" ] (
              lib.mergeAttrsList [
                (bind "Ctrl h" { MoveFocusOrTab = "Left"; })
                (bind "Ctrl l" { MoveFocusOrTab = "Right"; })
                (bind "Ctrl j" { MoveFocus = "Down"; })
                (bind "Ctrl k" { MoveFocus = "Up"; })
              ]
            ))
          ];
        };
      };

      fish.shellAbbrs = {
        zq = "${lib.getExe config.programs.zellij.package} kill-session $ZELLIJ_SESSION_NAME";
        zj = "${lib.getExe config.programs.zellij.package}";
      };
    };
  };
}
