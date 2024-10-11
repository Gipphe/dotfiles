{
  pkgs,
  lib,
  util,
  config,
  ...
}:
let
  cfg = config.gipphe.programs.zellij;
  inherit (config.gipphe.lib.zellij)
    section
    unbind
    shared_except
    bind
    ;
in
util.mkProgram {
  name = "zellij";

  options.gipphe.programs.zellij.layouts = lib.mkOption {
    description = "Layouts for Zellij";
    default = { };
    type =
      with lib.types;
      attrsOf (
        submodule (
          { name, config, ... }:
          {
            options = {
              enable = lib.mkOption {
                description = "Whether this layout should be generated.";
                type = lib.types.bool;
                default = true;
              };
              text = lib.mkOption {
                description = "Text contents for the layout.";
                type = with lib.types; nullOr lines;
                default = null;
              };
              source = lib.mkOption {
                description = "Path to the source file.";
                type = lib.types.path;
              };
            };
            config = {
              source = lib.mkIf (config.text != null) (
                lib.mkDefault (
                  pkgs.writeTextFile {
                    inherit (config) text;
                    name = util.storeFileName "zellij_layout_" name;
                  }
                )
              );
            };
          }
        )
      );
  };
  hm = {
    imports = [
      ./plugins
      ./helpers.nix
    ];
    gipphe.programs.zellij.layouts.main.source = ./layouts/main.kdl;
    xdg.configFile = lib.mapAttrs' (
      name: layout:
      let
        fullName = if lib.hasSuffix ".kdl" name then name else "${name}.kdl";
      in
      {
        name = "zellij/config/layouts/${fullName}";
        value = layout;
      }
    ) cfg.layouts;
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
                (bind "Ctrl u" { HalfPageScrollUp = [ ]; })
                (bind "Ctrl d" { HalfPageScrollDown = [ ]; })
                (bind "Ctrl f" { PageScrollDown = [ ]; })
                (bind "Ctrl b" { PageScrollUp = [ ]; })
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
