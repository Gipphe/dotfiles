{ den, inputs, ... }:
{
  # TODO: Remove once sodium or carbon hosts are back in place.
  flake.checks.aarch64-linux = { };
  # TODO: Fix for raspberry-pi
  # den.hosts.aarch64-linux.sodium = {
  #   users.gipphe = { };
  # };
  den.aspects.sodium = {
    includes = [
      den.aspects.profiles.nixos.networking
      den.aspects.profiles.nixos.system
      den.aspects.profiles.nixos.time
      # den.aspects.profiles.nixos.wifi
      # den.aspects.profiles.cli-slim
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
      den.aspects.programs.git
      den.aspects.programs.gnugrep
      den.aspects.programs.gnused
      den.aspects.programs.gnutar
      den.aspects.programs.less
      den.aspects.programs.nh
      den.aspects.programs.ripgrep
      den.aspects.programs.ssh
      den.aspects.programs.zoxide
    ];

    homeManager = {
      imports = [ inputs.stylix.homeModules.stylix ];
    };

    nixos =
      { user }:
      {
        lib,
        config,
        pkgs,
        ...
      }:
      {
        imports = [
          "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          inputs.stylix.nixosModules.stylix
        ];

        hardware.enableRedistributableFirmware = true;
        hardware.firmware = [ pkgs.raspberrypiWirelessFirmware ];
        hardware.bluetooth.enable = false;

        boot.zfs.forceImportRoot = true;
        boot.loader.grub.enable = false;
        boot.loader.generic-extlinux-compatible.enable = true;

        # WiFi driver fixes for Pi 4
        # Change regulatory domain to your country: https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
        boot.extraModprobeConfig = ''
          options cfg80211 ieee80211_regdom=NO
          options brcmfmac roamoff=1 feature_disable=0x82000
        '';
        networking.networkmanager.wifi.powersave = false;
        networking.networkmanager.ensureProfiles = {
          environmentFiles = lib.mkForce [ ];
          profiles.GiphtNet.wifi-security.psk = lib.mkForce "giphthopp";
        };

        # Unblock WiFi at boot (common Pi issue)
        systemd.services.rfkill-unblock-wifi = {
          description = "Unblock WiFi";
          wantedBy = [ "multi-user.target" ];
          before = [ "NetworkManager.service" ];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${pkgs.util-linux}/bin/rfkill unblock wifi";
            RemainAfterExit = true;
          };
        };

        # mDNS for raspberry.local
        services.avahi = {
          enable = true;
          nssmdns4 = true;
          settings.publish.disable-publishing = false;
          settings.publish.publish-addresses = true;
        };

        services.openssh.enable = true;
        systemd.services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];
        users.users.${user.userName} = {
          hashedPasswordFile = config.sensitive.secrets.secrets."sodium/gipphe-pw.txt";
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMmb8xuUFYGTMjI7OlwLkIlmcfi1cz/SiSB6Bx1Y0KYW gipphe@titanium"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHzghQHh1ZqXhTE2dplVJZPulAvPcaxdSziDotkJBWLs gipphe@boron"
          ];
        };

        system.stateVersion = "26.05";
        sdImage.compressImage = false;
      };
  };
}
