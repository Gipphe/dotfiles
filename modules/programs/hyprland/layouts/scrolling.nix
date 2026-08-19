{
  util,
  config,
  lib,
  ...
}:
let
  mod = config.gipphe.programs.hyprland.mod;
  dispatch = import ../dispatchers.nix { inherit lib; };
in
util.mkToggledModule [ "programs" "hyprland" "layouts" ] {
  name = "scrolling";
  homeManager = {
    wayland.windowManager.hyprland = {
      settings.config = {
        general.layout = "scrolling";
        scrolling = {
          fullscreen_on_one_column = true;
          column_width = 0.5;
          focus_fit_method = 1;
          follow_focus = true;
          follow_min_visible = 0.4;
          explicit_column_widths = "0.333, 0.5, 0.667, 1.0";
          wrap_focus = true;
          wrap_swapcol = true;
          direction = "right";
        };
      };
    };
    gipphe.programs.hyprland = {
      settings.bind = {
        # Move focus with `mod + hjkl`
        "${mod} + H".action = dispatch.layout "focus l";
        "${mod} + L".action = dispatch.layout "focus r";
        "${mod} + K".action = dispatch.layout "focus u";
        "${mod} + J".action = dispatch.layout "focus d";

        "${mod} + SHIFT + H".action = dispatch.layout "swapcol l";
        "${mod} + SHIFT + L".action = dispatch.layout "swapcol r";

        "${mod} + S".action = dispatch.submap "Scrolling";

        # Open the window in fullscreen
        "${mod} + F".action = dispatch.window.fullscreen { layout_aware = true; };

        # Toggle between layout controlled and floating window
        "${mod} + T".action = dispatch.window.float { };
      };
      submaps.Scrolling = {
        onDispatch = "reset";
        settings.bind = {
          "${mod} + S".action = dispatch.submap "reset";
          "Escape".action = dispatch.submap "reset";
          "S".action = dispatch.submap "reset";
          "F".action = dispatch.layout "fit expand";
          "SHIFT + F".action = dispatch.layout "fit_into_view";
          "L".action = dispatch.layout "expel";
          "H".action = dispatch.layout "consume";
          "K".action = dispatch.layout "promote";
          "SHIFT + L".action = dispatch.layout "colresize +conf";
          "SHIFT + H".action = dispatch.layout "colresize -conf";
        };
      };
    };
  };
}
