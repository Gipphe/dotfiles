{ den, inputs, ... }:
{
  den.hosts.aarch64-linux.sodium = {
    instantiate = inputs.nixos-raspberrypi.lib.nixosSystem;
    users.gipphe = { };
  };
  den.aspects.sodium = {
    includes = [
      den.aspects.system.networking.core
      den.aspects.profiles.nixos.system
      den.aspects.profiles.nixos.time
      den.aspects.profiles.core
      den.aspects.profiles.gc
      den.aspects.profiles.keyring
      den.aspects.profiles.secrets

      den.aspects.programs.atuin
      den.aspects.programs.bat
      den.aspects.programs.btop
      den.aspects.programs.curl
      den.aspects.programs.eza
      den.aspects.programs.fd
      den.aspects.programs.forgejo
      den.aspects.programs.git
      den.aspects.programs.gnugrep
      den.aspects.programs.gnused
      den.aspects.programs.gnutar
      den.aspects.programs.less
      den.aspects.programs.nh
      den.aspects.programs.podman
      den.aspects.programs.ripgrep
      den.aspects.programs.ssh
      den.aspects.programs.zoxide

      den.aspects.sodium.restic
    ];

    nixos =
      { user }:
      {
        config,
        lib,
        options,
        ...
      }:
      {
        imports = [
          inputs.nixos-raspberrypi.nixosModules.sd-image
        ]
        ++ builtins.attrValues {
          inherit (inputs.nixos-raspberrypi.nixosModules.raspberry-pi-4)
            base
            bluetooth
            display-vc4
            ;
          inherit (inputs.nixos-raspberrypi.nixosModules)
            usb-gadget-ethernet
            ;
        };

        boot = {
          zfs.forceImportRoot = false;
          # # WiFi driver fixes for Pi 4
          # # Change regulatory domain to your country: https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
          extraModprobeConfig = ''
            options cfg80211 ieee80211_regdom=NO
          '';
          # options brcmfmac roamoff=1 feature_disable=0x82000
        };

        networking.networkmanager.wifi.powersave = false;

        # # mDNS for raspberry.local
        services.avahi = {
          enable = true;
          nssmdns4 = true;
        }
        // (
          if (options.services.avahi ? settings) then
            {
              settings.publish = {
                disable-publishing = false;
                publish-addresses = true;
              };
            }
          else
            {
              publish = {
                enable = true;
                addresses = true;
              };
            }
        );

        users.users.${user.userName} = {
          hashedPasswordFile = config.sensitive.secrets.secrets."sodium/gipphe-pw.txt";
          # Fixed so the image-injected sops key can be chowned to the right
          # owner before the system has ever booted.
          uid = 1000;
        };
        # The shared systemd aspect disables getty on tty1 (desktop hosts use a
        # greeter instead). This host has no greeter, so bring the login prompt
        # back, otherwise there's no console to debug from.
        systemd.services = {
          "getty@tty1".enable = lib.mkForce true;
          "autovt@tty1".enable = lib.mkForce true;
        };

        # This host is built with nixos-raspberrypi's nixpkgs, but the shared
        # nix module pins the registry's `nixpkgs` to this flake's input. Make
        # the NixOS-provided registry entry agree with it.
        nixpkgs.flake.source = lib.mkForce inputs.nixpkgs.outPath;

        system.stateVersion = "26.10";
        sdImage.compressImage = false;

        nix.settings = {
          trusted-substituters = [ "https://nixos-raspberrypi.cachix.org" ];
          trusted-public-keys = [
            "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
          ];
        };
      };
  };
}
