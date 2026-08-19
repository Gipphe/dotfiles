{
  pkgs,
  lib,
  util,
  inputs,
  config,
  ...
}:
let
  ipc = "${lib.getExe' config.programs.noctalia.package "noctalia"} msg";
  wallpaperDir = "Pictures/wallpapers";
  noctalia-copy-gui-settings = pkgs.callPackage ./scripts/noctalia-copy-gui-settings.nix {
    noctalia = config.programs.noctalia.package;
  };
  noctalia-diff-settings = pkgs.callPackage ./scripts/noctalia-diff-settings.nix {
    noctalia = config.programs.noctalia.package;
  };

  main = util.mkProgram {
    name = "noctalia";
    shared = {
      imports = [
        ./plugins/screen-toolkit.nix
        ./plugins/hypr-layout-switcher.nix
        ./plugins/hypr-submap.nix
        ./plugins/special-workspaces.nix
      ];
      gipphe.programs.noctalia.plugins = {
        hypr-layout-switcher.enable = true;
        hypr-submap.enable = true;
        screen-toolkit.enable = true;
        special-workspaces.enable = true;
      };
    };
    homeManager = {
      imports = [ inputs.noctalia.homeModules.default ];
      programs.noctalia = {
        enable = true;
        systemd.enable = true;
        package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
        settings = lib.mkMerge [
          {
            shell.avatar_path = lib.mkForce ../../../assets/profile.png;
            wallpaper.directory = lib.mkForce "${config.home.homeDirectory}/${wallpaperDir}";
          }
          (import ./settings.nix)
        ];
      };
      home = {
        file = {
          "${wallpaperDir}/small-memory.png".source = config.stylix.image;
        };
        packages = [
          noctalia-copy-gui-settings
          noctalia-diff-settings
          pkgs.socat # Required for hypr-submap plugin
        ];
      };
      gipphe.core.wm.bind = {
        "SUPER + space".action.spawn = "${ipc} panel-toggle launcher";
        "SUPER + C".action.spawn = "${ipc} panel-toggle clipboard";
      };
    };
    nixos = {
      networking.networkmanager.enable = true;
      hardware.bluetooth.enable = true;
      services = {
        auto-cpufreq.enable = lib.mkForce false;
        power-profiles-daemon.enable = true;
        upower.enable = true;
      };
    };
  };
in
util.mkModule {
  shared.imports = [ main ];
  nixos.nix.settings = {
    trusted-substituters = [ "https://noctalia.cachix.org" ];
    trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };
}
