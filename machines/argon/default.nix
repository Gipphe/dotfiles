{
  config,
  lib,
  hostname,
  util,
  ...
}:
let
  host = import ./host.nix;
in
util.mkToggledModule [ "machines" ] {
  inherit (host) name;
  shared = {
    gipphe = {
      username = "gipphe";
      homeDirectory = "/home/gipphe";
      hostName = host.name;
      profiles = {
        nixos = {
          networking.enable = true;
          system.enable = true;
          time.enable = true;
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
        sync.enable = true;
        systemd.enable = true;
        terminal-capture.enable = true;
        tweag.enable = true;
        vm-guest.enable = true;
        windows-setup.enable = true;
      };
      programs = {
        wezterm.enable = true;
      };
    };
  };
  hm = {
    services.syncthing.tray.enable = lib.mkForce false;
    programs.ssh.matchBlocks."sodium.lan" = {
      hostname = "sodium.lan";
      user = "gipphe";
      identityFile = config.sops.secrets."argon-sodium.ssh".path;
    };
    sops.secrets."argon-sodium.ssh" = {
      format = "binary";
      sopsFile = ../../secrets/argon-sodium.ssh;
    };
  };

  system-nixos = {
    imports = lib.optionals (hostname == host.name) [ ./hardware-configuration.nix ];
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
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
