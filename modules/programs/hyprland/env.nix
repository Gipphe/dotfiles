{ util, ... }:
util.mkModule {
  hm = {
    wayland.windowManager.hyprland = {
      settings = {
        env = [
          # Cursor
          "XCURSOR_SIZE,24"

          # XDG Desktop Portal
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "XDG_SESSION_DESKTOP,Hyprland"

          # QT
          "QT_QPA_PLATFORM,wayland;xcb"
          "QT_QPA_PLATFORMTHEME,qt6ct"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          "QT_AUTO_SCREEN_SCALE_FACTOR,1"

          # GTK
          "GDK_SCALE,1"

          # Mozilla
          "MOZ_ENABLE_WAYLAND,1"

          # Disable appimage launcher by default
          "APPIMAGELAUNCHER_DISABLE,1"

          # OZONE
          "OZONE_PLATFORM,wayland"
        ];
      };
    };
    home.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
