{ lib, util, ... }:
util.mkToggledModule [ "machines" ] {
  name = "argon";
  shared = {
    gipphe = {
      username = "gipphe";
      homeDirectory = "/home/gipphe";
      hostName = "argon";
      profiles = {
        nixos = {
          system.enable = true;
          wsl.enable = true;
        };
        ai.enable = true;
        cli.enable = true;
        containers.enable = true;
        core.enable = true;
        fonts.enable = true;
        game-dev.enable = false;
        gc.enable = true;
        rice.enable = true;
        secrets.enable = true;
        systemd.enable = true;
        terminal-capture.enable = true;
        vm-guest.enable = true;
        windows-setup.enable = true;
      };
      programs = {
        build-host.enable = true;
        wezterm.enable = true;
      };
    };
  };

  system-nixos = {
    users = {
      users = {
        gipphe.uid = lib.mkForce 1001;
      };
      groups = {
        gipphe.gid = lib.mkForce 997;
        docker.gid = lib.mkForce 996;
      };
    };
  };
}
