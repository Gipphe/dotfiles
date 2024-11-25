{ lib, util, ... }:
util.mkToggledModule [ "machines" ] {
  name = "Jarle-wsl";
  shared = {
    gipphe = {
      username = "gipphe";
      homeDirectory = "/home/gipphe";
      hostName = "Jarle-wsl";
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
        programming.haskell.enable = true;
        rice.enable = true;
        secrets.enable = true;
        systemd.enable = true;
        vm-guest.enable = true;
        windows-setup.enable = true;
        work-slim.enable = true;
        work-wsl.enable = true;
      };
      programs.wezterm.enable = true;
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
