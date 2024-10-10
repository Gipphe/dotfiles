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
  unbind = keys: {
    "unbind \"${keys}\"" = [ ];
  };
  bind = keys: opts: { "bind \"${keys}\"" = opts; };
  section = section: opts: { "${section}" = opts; };
  shared_except = modes: opts: { "shared_except \"${lib.concatStringsSep "\" \"" modes}\"" = opts; };
in
util.mkProgram {
  name = "zellij";

  hm = {
    xdg.configFile = {
      "zellij/layouts".source = ./layouts;
      "zellij/plugins/zj_forgot.wasm".source = zj_forgot;
    };
    programs = {
      zellij.enable = true;

      settings = {
        # copy_command = "xclip -in -sel clip";
        copy_on_select = true;
        theme = "catppuccin-macchiato";
        ui = {
          pane_frames = {
            rounded_corners = false;
          };
        };
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
              (bind "Ctrl j" { MoveFocusOrTab = "Down"; })
              (bind "Ctrl k" { MoveFocusOrTab = "Up"; })
              (bind "Ctrl y" {
                "LaunchOrFocusPlugin \"file:~/.config/zellij/plugins/zj_forgot.wasm\"" = {
                  floating = true;
                };
              })
            ]
          ))
        ];
      };

      fish.shellAbbrs = {
        zq = "${lib.getExe config.programs.zellij.package} kill-session $ZELLIJ_SESSION_NAME";
        zj = "${lib.getExe config.programs.zellij.package}";
      };
    };
  };
}
