# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL
{
  inputs,
  lib,
  config,
  pkgs,
  flags,
  ...
}:
lib.optionalAttrs flags.wsl {
  imports = [
    # include NixOS-WSL modules
    inputs.wsl.nixosModules.default
  ];

  wsl = {
    enable = true;
    defaultUser = "gipphe";
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

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };
  systemd.services.docker-desktop-proxy.script = lib.mkForce ''
    ${config.wsl.wslConf.automount.root}/wsl/docker-desktop/docker-desktop-user-distro proxy --docker-desktop-root ${config.wsl.wslConf.automount.root}/wsl/docker-desktop "C:\Program Files\Docker\Docker\resources"
  '';
}
