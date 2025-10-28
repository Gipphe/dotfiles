{
  util,
  pkgs,
  config,
  ...
}:
util.mkProgram {
  name = "build-host";
  system-nixos =
    let
      qemu-aarch64-static = pkgs.stdenv.mkDerivation {
        name = "qemu-aarch64-static";

        src = builtins.fetchurl {
          url = "https://github.com/multiarch/qemu-user-static/releases/download/v5.1.0-7/qemu-aarch64-static";
          sha256 = "0yzlrlknslvas58msrbbq3hazphyydrbaqrd840bd1c7vc9lcrh6";
        };

        dontUnpack = true;
        installPhase = "install -D -m 0755 $src $out/bin/qemu-aarch64-static";
      };
    in
    {
      boot.binfmt.registrations.aarch64 = {
        interpreter = "${qemu-aarch64-static}/bin/qemu-aarch64-static";
        magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7\x00'';
        mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\x00\xff\xfe\xff\xff\xff'';
      };
      nix = {
        settings = {
          trusted-users = [ "builder" ];
          extra-platforms = "aarch64-linux";
        };
        extraOptions = ''
          sandbox-paths = "/bin/sh=${pkgs.busybox-sandbox-shell}/bin/busybox /run/binfmt/aarch64=${qemu-aarch64-static}/bin/qemu-aarch64-static"
        '';
      };
      users.users.builder = {
        isNormalUser = true;
        createHome = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFZzdNC8yhKhkFcsLOPkKa4xmacFGFY8LLpQ0bPhfRGB"
        ];
      };
      services.openssh = {
        enable = true;
        ports = [ 9022 ];
        extraConfig = ''
          HostKey ${config.sops.secrets."argon-sshd.ssh".path}
        '';
      };
      # Prevent generating host key, and use pregenerated host key instead.
      # This will conflict with all other openssh/sshd configs in this repo.
      systemd.services.sshd-keygen.enable = false;
      sops.secrets = {
        "building-carbon.ssh.pub" = {
          format = "binary";
          sopsFile = ../../../secrets/building-carbon.ssh.pub;
        };
        "argon-sshd.ssh" = {
          format = "binary";
          sopsFile = ../../../secrets/argon-sshd.ssh;
        };
      };
    };
}
