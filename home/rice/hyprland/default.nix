{
  pkgs,
  lib,
  inputs,
  theme,
  ...
}:
with lib;
let
  mkService = lib.recursiveUpdate {
    Unit.PartOf = [ "graphical-session.target" ];
    Unit.After = [ "graphical-session.target" ];
    Install.WantedBy = [ "graphical-session.target" ];
  };
in
{
  imports = [
    ./config.nix
    ./binds.nix
    ./rules.nix
  ];
  home.packages =
    with pkgs;
    with inputs.hyprcontrib.packages.${pkgs.system};
    [

      # Forward notifications to notification daemon
      libnotify

      # Screen recording
      wf-recorder

      # Control screen brightess
      brightnessctl

      # Pulseaudio mixer for terminal
      pamixer

      # TODO: figure out whether this one is necessary
      # HTTP requests library
      python39Packages.requests

      # Select screen region
      slurp

      # Grab images from the screen
      grim

      # Screenshot helper for Hyprland
      grimblast

      # Color picker
      hyprpicker

      # Snapshot editing tool
      swappy

      # Persist clipboard after program close
      wl-clip-persist

      # CLI tool for copy/paste
      wl-clipboard

      # Convert 24/32-bit PNGs to 8-bit PNGs, preserving alpha
      pngquant

      # Clipboard manager
      cliphist

      # Color pick from screen
      (writeShellScriptBin "pauseshot" ''
        ${hyprpicker}/bin/hyprpicker -r -z &
        picker_proc=$!

        ${grimblast}/bin/grimblast save area - | tee ~/pics/ss$(date +'screenshot-%F') | wl-copy

        kill $picker_proc
      '')

      # Toggle mic mute and light
      (writeShellScriptBin "micmute" ''
        #!/bin/sh

        # shellcheck disable=SC2091
        if $(pamixer --default-source --get-mute); then
          pamixer --default-source --unmute
          sudo mic-light-off
        else
          pamixer --default-source --mute
          sudo mic-light-on
        fi
      '')
    ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.default;
    # systemd = {
    #   variables = [ "--all" ];
    #   extraCommands = [
    #     "systemctl --user stop graphical-session.target"
    #     "systemctl --user start hyprland-session.target"
    #   ];
    # };
  };

  services = {
    # Original comment:
    # > yeah, I could've just used waybar, but coding this thing was fun. both
    # > use pretty much same libs so memory usage is comparable
    # It is disabled in sioodmy's config, so it's likely he changed back to
    # waybar.
    # barbie.enable = false;
    wlsunset = {
      # TODO: fix opaque red screen issue
      enable = true;
      latitude = "52.0";
      longitude = "21.0";
      temperature = {
        day = 6200;
        night = 3750;
      };
      systemdTarget = "hyprland-session.target";
    };
  };

  # Fake a tray to let apps start
  # https://github.com/nix-community/home-manager/issues/2064
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

  systemd.user.services = {
    swaybg = mkService {
      Unit.Description = "Wallpaper chooser";
      Service = {
        ExecStart = "${lib.getExe pkgs.swaybg} -i ${theme.wallpaper}";
        Restart = "always";
      };
    };
  };
}
