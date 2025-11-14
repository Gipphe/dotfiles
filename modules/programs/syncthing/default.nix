{
  lib,
  util,
  config,
  ...
}:
let
  folders = {
    "${config.home.homeDirectory}/Notes" = {
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
        "boron"
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
    "${config.home.homeDirectory}/Lorelei and the Laser Eyes notes" = {
      id = "lorelei-and-the-laser-eyes-notes";
      label = "Lorelei and the Laser Eyes";
      devices = [
        "titanium"
        "boron"
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
  hm = {
    services.syncthing = {
      enable = true;
      overrideDevices = true;
      overrideFolders = true;
      passwordFile = config.sops.secrets."syncthing-password".path;
      settings = {
        devices = {
          argon.id = "GKVPGI5-YOS5SQK-VFMDIPM-EIQ4NOI-72TYKH3-TU7FR4X-IUOX55J-7NEEYQY";
          boron.id = "4AGB4CH-53R7AD2-U6YUREI-QXX77WS-IAZ3YWG-T4OBNWN-VQAVA2P-5FNBGAU";
          carbon.id = "A7LZMEF-DMVXRLI-KB3RWZ5-QLYUX7R-MK43GT5-TIRZHHD-VY6NIZ6-MRVCZAA";
          cobalt.id = "5WAUGFG-XWLSBTV-IJMCB5F-YGN7AZM-RQ2FQOT-7SWUF7Q-7OUZKSR-JBZX3AK";
          helium.id = "XM4OOHL-EP23EPU-63QRPZY-TLLMY45-JPJ5TDB-MB6LZ6J-3UO7W2A-RLOVVA2";
          titanium.id = "MPSR6F6-NO6UV52-VWGSMR2-BQSANDW-HSOCRQ4-XDHZHLC-4JJ4AJE-QBYXIAA";
        };
        folders = foldersForThisHost;
      };
      tray.enable = true;
    };
    sops.secrets."syncthing-password" = {
      sopsFile = ../../../secrets/pub-syncthing-password;
      mode = "400";
      format = "binary";
    };
  };
  system-nixos.networking.firewall = {
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
