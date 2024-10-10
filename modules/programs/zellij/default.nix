{
  lib,
  util,
  config,
  pkgs,
  ...
}:
let
  zj_forgot = pkgs.fetchurl {
    url = "https://github.com/karimould/zellij-forgot/releases/download/0.3.0/zellij_forgot.wasm";
    hash = "sha256-JNQ4KXb6VzjSF0O4J8Tvq3FXUYBBabQb9ZitcR3kZFw=";
  };
in
util.mkProgram {
  name = "zellij";

  hm = {
    xdg.configFile = {
      "zellij/layouts".source = ./layouts;
      "zellij/config.kdl".text = # kdl
        ''
          // copy_command "xclip -in -sel clip"
          copy_on_select true
          theme "catppuccin-macchiato"
          keybinds {
            unbind "Ctrl q"
            unbind "Ctrl o"

            move {
              bind "Ctrl e" { SwitchToMode "Normal"; }
            }
            shared_except "move" "locked" {
              bind "Ctrl e" { SwitchToMode "Move"; }
            }

            session {
              bind "Ctrl x" { SwitchToMode "Normal"; }
            }
            shared_except "session" "locked" {
              bind "Ctrl x" { SwitchToMode "Session"; }
            }

            shared_except "locked" {
              bind "Ctrl h" { MoveFocusOrTab "Left"; }
              bind "Ctrl l" { MoveFocusOrTab "Right"; }
              bind "Ctrl j" { MoveFocus "Down"; }
              bind "Ctrl k" { MoveFocus "Up"; }

              bind "Ctrl y" {
                LaunchOrFocusPlugin "file:${zj_forgot}" {
                  floating true
                }
              }
            }
          }
          ui {
            pane_frames {
              rounded_corners false
            }
          }
        '';
    };
    programs = {
      zellij.enable = true;

      fish.shellAbbrs = {
        zq = "${lib.getExe config.programs.zellij.package} kill-session $ZELLIJ_SESSION_NAME";
        zj = "${lib.getExe config.programs.zellij.package}";
      };
    };
  };
}
