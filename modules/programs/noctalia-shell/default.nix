{
  pkgs,
  lib,
  util,
  inputs,
  config,
  ...
}:
let
  ipc = "${lib.getExe' config.programs.noctalia-shell.package "noctalia-shell"} ipc call";
  wallpaperDir = "Pictures/wallpapers";
in
util.mkProgram {
  name = "noctalia-shell";
  hm = {
    imports = [ inputs.noctalia-shell.homeModules.default ];
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
    home.file = {
      ".face".source = ../../../assets/profile.png;
      "${wallpaperDir}/small-memory.png".source = config.stylix.image;
    };
    home.packages = [
      (pkgs.writeShellApplication {
        name = "noctalia-copy-gui-settings";
        runtimeInputs = [ pkgs.nix ];
        runtimeEnv.dest = "${config.home.homeDirectory}/projects/dotfiles/modules/programs/noctalia-shell/settings.nix";
        text = /* bash */ ''
          nix eval --expr 'builtins.fromJSON (builtins.readFile "${config.xdg.configHome}/noctalia/gui-settings.json")' --impure > "$dest"
          nixfmt "$dest"
        '';
      })
      (pkgs.writeShellApplication {
        name = "noctalia-diff-settings";
        runtimeInputs = builtins.attrValues {
          inherit (pkgs)
            colordiff
            diffutils
            jq
            ;
        };
        text = /* bash */ ''
          diff -u \
            <(jq -S . "$HOME/.config/noctalia/settings.json") \
            <(jq -S . "$HOME/.config/noctalia/gui-settings.json") \
            | colordiff --nobanner
        '';
      })
    ];
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
    networking.networkmanager.enable = true;
    hardware.bluetooth.enable = true;
    services = {
      auto-cpufreq.enable = lib.mkForce false;
      power-profiles-daemon.enable = true;
      upower.enable = true;
    };
  };
}
