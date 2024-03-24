{ pkgs, ... }:
{
  config = {
    programs.hyprland = {
      enable = true;

      # Necessary to run X applications in wayland
      xwayland.enable = true;
    };

    environment.systemPackages = with pkgs; [
      # The simple bar solution
      (waybar.overrideAttrs (oldAttrs: {
        # Workspaces might not display correctly without this.
        # TODO: test without
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      }))

      # The rabbit hole bar: Elkowar's Wacky Widgets
      # eww

      # Tried and tested notification manager
      dunst

      # New and wayland native notification manager
      # mako

      # Notification protocol layer between mako/dunst and the OS
      libnotify

      # Wallpaper daemon:
      # hyprpaper
      # swaybg
      # wpaperd
      # mpvpaper
      swww

      # hyprland's default terminal
      kitty

      # App launcher
      rofi-wayland

      # GTK rofi
      # wofi

      # hyprland wiki also suggests
      # bemenu
      # fuzzel
      # tofi # used by sioodmy

      neovim
      firefox

      # qt5-wayland
      # qt5c
      # libva
    ];

    # XDG stuff for tying all the stuff together
    # xdg.portal = {
    #   enable = true;
    #   extraPortals = [
    #     pkgs.xdg-desktop-portal-gtk
    #     pkgs.xdg-desktop-portal-hyprland
    #   ];
    # };

    environment.sessionVariables = {
      # If your cursor becomes invisible
      # WLR_NO_HARDWARE_CURSORS = "1";
      # Hint electron apps to use wayland. Black screen in electron apps is an
      # indication that the app is not using wayland.
      NIXOS_OZONE_WL = "1";
      XDG_SESSION_TYPE = "wayland";
    };

    hardware = {
      # Opengl
      opengl.enable = true;
    };
  };
}
