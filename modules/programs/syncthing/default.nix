{
  lib,
  util,
  config,
  ...
}:
let
  cfg = config.gipphe.programs.syncthing;
  folders = {
    "${config.home.homeDirectory}/Documents/Backups" = {
      id = "backups";
      label = "Backups";
      devices = [
        "carbon"
        "titanium"
      ];
    };
    "${config.home.homeDirectory}/Documents/Notes" = {
      id = "notes";
      label = "Notes";
      devices = [
        "argon"
        "carbon"
        "cobalt"
        "helium"
        "titanium"
        "boron"
      ];
    };
    "${config.home.homeDirectory}/Dwarf Fortress saves" = {
      id = "df-saves";
      label = "Dwarf Fortress saves";
      devices = [
        "cobalt"
        "titanium"
        "boron"
      ];
    };
    "${config.home.homeDirectory}/.local/share/Tachiyomi Backups" = {
      id = "tachiyomi-backups";
      label = "Tachiyomi Backups";
      devices = [
        "carbon"
        "cobalt"
        "titanium"
      ];
    };
    "${config.home.homeDirectory}/.local/share/gdlauncher_carbon/data/instances" = {
      id = "gdlauncher-instances";
      label = "GDLauncher instances";
      devices = [
        "titanium"
        "boron"
      ];
    };
    "${config.home.homeDirectory}/.local/share/PrismLauncher/instances" = {
      id = "prismlauncher-instances";
      label = "PrismLauncher instances";
      devices = [
        "titanium"
        "boron"
      ];
    };
    "/mnt/oldone/Filen/Archive/Backup/PhoneProfilesPlus settings" = {
      id = "phone-profiles-plus-settings";
      lable = "PhoneProfilesPlus settings";
      devices = [
        "titanium"
        "carbon"
      ];
    };
    "/mnt/oldone/Filen/Archive/Backup/AnkiDroid" = {
      id = "ankidroid";
      lable = "AnkiDroid";
      devices = [
        "titanium"
        "carbon"
      ];
    };
  };

  inherit (builtins) elem filter;
  inherit (config.gipphe) hostName;
  inherit (lib) filterAttrs mapAttrs pipe;

  foldersForThisHost = pipe folders [
    (filterAttrs (_: v: elem hostName v.devices))
    (mapAttrs (
      _: v:
      v
      // {
        devices = filter (x: x != hostName) v.devices;
      }
    ))
  ];
in
util.mkProgram {
  name = "syncthing";
  options.gipphe.programs.syncthing.guiCredentials.passwordFile = lib.mkOption {
    type = with lib.types; either path str;
    description = "Path to password file";
  };
  homeManager = {
    services.syncthing = {
      enable = true;
      overrideDevices = true;
      overrideFolders = true;
      guiCredentials = {
        username = "syncthing";
        passwordFile = cfg.guiCredentials.passwordFile;
      };
      settings = {
        devices = removeAttrs {
          argon.id = "GKVPGI5-YOS5SQK-VFMDIPM-EIQ4NOI-72TYKH3-TU7FR4X-IUOX55J-7NEEYQY";
          boron.id = "SXGT2PL-UCGX25P-FVA6ZHZ-5RWMOFN-VY4YVG2-MKZLEGE-AIDTEX6-AEAGHA5";
          carbon.id = "A7LZMEF-DMVXRLI-KB3RWZ5-QLYUX7R-MK43GT5-TIRZHHD-VY6NIZ6-MRVCZAA";
          cobalt.id = "5WAUGFG-XWLSBTV-IJMCB5F-YGN7AZM-RQ2FQOT-7SWUF7Q-7OUZKSR-JBZX3AK";
          helium.id = "XM4OOHL-EP23EPU-63QRPZY-TLLMY45-JPJ5TDB-MB6LZ6J-3UO7W2A-RLOVVA2";
          titanium.id = "Z3CD5KT-7UGJE7V-JHN37MQ-DFFA6N7-EZMRJ7B-GCB3WMN-5BTVUMG-AICT7QD";
        } [ hostName ];
        folders = foldersForThisHost;
      };
      tray.enable = true;
    };
  };
  nixos.networking.firewall = {
    allowedTCPPorts = [
      8384
      22000
    ];
    allowedUDPPorts = [
      22000
      21027
    ];
  };
}
