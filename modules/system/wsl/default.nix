{
  lib,
  inputs,
  pkgs,
  config,
  util,
  ...
}:
util.mkToggledModule [ "system" ] {
  name = "wsl";

  hm.programs.fish.shellAbbrs.rmz = "find . -name '*Zone.Identifier' -type f -delete";

  system-nixos = {
    imports = [
      # include NixOS-WSL modules
      inputs.wsl.nixosModules.default
    ];

    config = {
      wsl = {
        enable = true;
        defaultUser = config.gipphe.username;
        docker-desktop.enable = false;
        interop = {
          includePath = true;
          # register = true;
          # startMenuLaunchers = true;
        };
        extraBin = with pkgs; [
          # Binaries for Docker Desktop wsl-distro-proxy
          { src = "${coreutils}/bin/mkdir"; }
          { src = "${coreutils}/bin/cat"; }
          { src = "${coreutils}/bin/whoami"; }
          { src = "${coreutils}/bin/ls"; }
          { src = "${busybox}/bin/addgroup"; }
          { src = "${su}/bin/groupadd"; }
          { src = "${su}/bin/usermod"; }
        ];
      };

      virtualisation.docker = lib.mkIf config.gipphe.programs.docker.enable {
        enable = true;
        enableOnBoot = true;
        autoPrune.enable = true;
      };
      systemd = lib.mkIf config.gipphe.system.systemd.enable {
        services.docker-desktop-proxy.script = lib.mkForce ''
          ${config.wsl.wslConf.automount.root}/wsl/docker-desktop/docker-desktop-user-distro proxy --docker-desktop-root ${config.wsl.wslConf.automount.root}/wsl/docker-desktop "C:\Program Files\Docker\Docker\resources"
        '';
      };
    };
  };
}
