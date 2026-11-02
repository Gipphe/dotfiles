{ den, inputs, ... }:
{
  den.aspects.programs.noctalia = {
    includes = [ den.aspects.programs.noctalia.plugins._ ];
    homeManager =
      { user }:
      {
        lib,
        config,
        pkgs,
        ...
      }:
      let
        ipc = "${lib.getExe' config.programs.noctalia.package "noctalia"} msg";
        wallpaperDir = "Pictures/wallpapers";
        noctalia-copy-gui-settings = pkgs.callPackage ./_scripts/noctalia-copy-gui-settings.nix {
          noctalia = config.programs.noctalia.package;
        };
        noctalia-diff-settings = pkgs.callPackage ./_scripts/noctalia-diff-settings.nix {
          noctalia = config.programs.noctalia.package;
        };
      in
      {
        imports = [ inputs.noctalia.homeModules.default ];
        programs.noctalia = {
          enable = true;
          systemd.enable = true;
          package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
          settings = lib.mkMerge [
            {
              shell.avatar_path = lib.mkForce ../../../assets/profile.png;
              wallpaper.directory = lib.mkForce "${user.homeDirectory}/${wallpaperDir}";
            }
            (import ./_settings.nix)
          ];
        };
        home = {
          file = {
            "${wallpaperDir}/small-memory.png".source = config.stylix.image;
          };
          packages = [
            noctalia-copy-gui-settings
            noctalia-diff-settings
          ];
        };
        gipphe.core.wm.bind = {
          "SUPER + space".action.spawn = "${ipc} panel-toggle launcher";
          "SUPER + C".action.spawn = "${ipc} panel-toggle clipboard";
        };
        stylix.targets.noctalia.enable = false;
      };
    nixos = { lib, ... }: {
      networking.networkmanager.enable = true;
      hardware.bluetooth.enable = true;
      services = {
        auto-cpufreq.enable = lib.mkForce false;
        power-profiles-daemon.enable = true;
        upower.enable = true;
      };
      nix.settings = {
        trusted-substituters = [ "https://noctalia.cachix.org" ];
        trusted-public-keys = [
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        ];
      };
    };
  };
}
