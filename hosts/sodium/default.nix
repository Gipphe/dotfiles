{
  config,
  pkgs,
  hostname,
  util,
  inputs,
  lib,
  ...
}:
let
  host = import ./host.nix;
  username = "gipphe";
in
util.mkToggledModule [ "machines" ] {
  inherit (host) name;

  shared.gipphe = {
    inherit username;
    homeDirectory = "/home/${username}";
    hostName = host.name;
    profiles = {
      nixos = {
        networking.enable = true;
        system.enable = true;
        time.enable = true;
        # wifi.enable = true;
      };
      # cli-slim.enable = true;
      core.enable = true;
      gc.enable = true;
      keyring.enable = true;
      secrets.enable = true;
    };

    programs = {
      atuin.enable = true;
      bat.enable = true;
      btop.enable = true;
      curl.enable = true;
      eza.enable = true;
      fd.enable = true;
      git.enable = true;
      gnugrep.enable = true;
      gnused.enable = true;
      gnutar.enable = true;
      less.enable = true;
      nh.enable = true;
      ripgrep.enable = true;
      ssh.enable = true;
      zoxide.enable = true;
    };
  };

  homeManager.imports = lib.optionals (hostname == host.name) [
    inputs.stylix.homeModules.stylix
  ];

  nixos = lib.optionalAttrs (hostname == host.name) {
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
      publish.enable = true;
      publish.addresses = true;
    };

    services.openssh.enable = true;
    systemd.services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];
    users.users.${username} = {
      hashedPasswordFile = config.sops.secrets."sodium-gipphe-pw.txt".path;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMmb8xuUFYGTMjI7OlwLkIlmcfi1cz/SiSB6Bx1Y0KYW gipphe@titanium"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHzghQHh1ZqXhTE2dplVJZPulAvPcaxdSziDotkJBWLs gipphe@boron"
      ];
    };
    sops.secrets."sodium-gipphe-pw.txt" = {
      format = "binary";
      neededForUsers = true;
      sopsFile = ../../secrets/sodium-gipphe-pw.txt;
    };

    system.stateVersion = "26.05";
    sdImage.compressImage = false;
  };
}
