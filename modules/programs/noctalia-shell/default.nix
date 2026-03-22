{
  pkgs,
  lib,
  util,
  inputs,
  config,
  osConfig,
  ...
}:
let
  ipc = "${lib.getExe' config.programs.noctalia-shell.package "noctalia-shell"} ipc call";
  wallpaperDir = "Pictures/wallpapers";
  noctalia-copy-gui-settings = pkgs.callPackage ./scripts/noctalia-copy-gui-settings.nix { };
  noctalia-diff-settings = pkgs.callPackage ./scripts/noctalia-diff-settings {
    noctalia-shell = config.services.noctalia-shell.package;
  };
in
util.mkProgram {
  name = "noctalia-shell";
  hm = {
    imports = [ inputs.noctalia.homeModules.default ];
    programs.noctalia-shell = lib.mkMerge [
      {
        enable = true;
        systemd.enable = true;
        settings = {
          bar = {
            backgroundOpacity = lib.mkForce 1;
            capsuleOpacity = lib.mkForce 1;
          };
          dock = {
            backgroundOpacity = lib.mkForce 1;
          };
          general = {
            avatarImage = lib.mkForce "${config.home.homeDirectory}/${config.home.file.".face".target}";
          };
          notifications = {
            backgroundOpacity = lib.mkForce 1;
          };
          osd = {
            backgroundOpacity = lib.mkForce 1;
          };
          ui = {
            panelBackgroundOpacity = lib.mkForce 1;
          };
          wallpaper = {
            directory = lib.mkForce "${config.home.homeDirectory}/${wallpaperDir}";
          };
        };
      }
      {
        settings = import ./settings.nix;
      }
    ];
    home = {
      file = {
        ".face".source = ../../../assets/profile.png;
        "${wallpaperDir}/small-memory.png".source = config.stylix.image;
      };
      packages = [
        noctalia-copy-gui-settings
        noctalia-diff-settings
      ];
    };
    gipphe.core.wm.binds = [
      {
        mod = "Mod";
        key = "space";
        action.spawn = "${ipc} launcher toggle";
      }
      {
        mod = "Mod";
        key = "C";
        action.spawn = "${ipc} launcher clipboard";
      }
    ];
  };
  system-nixos = {
    # imports = [
    #   inputs.noctalia.nixosModules.default
    # ];
    networking.networkmanager.enable = true;
    hardware.bluetooth.enable = true;
    services = {
      auto-cpufreq.enable = lib.mkForce false;
      power-profiles-daemon.enable = true;
      upower.enable = true;

      # noctalia-shell.enable = true;
    };
  };
}
