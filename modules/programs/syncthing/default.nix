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
        "carbon"
        "cobalt"
        "helium"
        "titanium"
        "utv-vnb-lt"
      ];
    };
    "${config.home.homeDirectory}/Dwarf Fortress saves" = {
      id = "df-saves";
      label = "Dwarf Fortress saves";
      devices = [
        "cobalt"
        "titanium"
        "utv-vnb-lt"
      ];
    };
    "${config.home.homeDirectory}/.local/share/Tachiyomi Backups" = {
      id = "tachiyomi-backups";
      label = "Tachiyomi Backups";
      devices = [
        "carbon"
        "cobalt"
        "titanium"
        "utv-vnb-lt"
      ];
    };
    "${config.home.homeDirectory}/.local/share/gdlauncher_carbon/data/instances" = {
      id = "gdlauncher-instances";
      label = "GDLauncher instances";
      devices = [
        "titanium"
        "utv-vnb-lt"
      ];
    };
    "${config.home.homeDirectory}/.local/share/PrismLauncher/instances" = {
      id = "prismlauncher-instances";
      label = "PrismLauncher instances";
      devices = [
        "titanium"
        "utv-vnb-lt"
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
          "titanium".id = "MPSR6F6-NO6UV52-VWGSMR2-BQSANDW-HSOCRQ4-XDHZHLC-4JJ4AJE-QBYXIAA";
          "helium".id = "XM4OOHL-EP23EPU-63QRPZY-TLLMY45-JPJ5TDB-MB6LZ6J-3UO7W2A-RLOVVA2";
          "cobalt".id = "5WAUGFG-XWLSBTV-IJMCB5F-YGN7AZM-RQ2FQOT-7SWUF7Q-7OUZKSR-JBZX3AK";
          "carbon".id = "A7LZMEF-DMVXRLI-KB3RWZ5-QLYUX7R-MK43GT5-TIRZHHD-VY6NIZ6-MRVCZAA";
          "utv-vnb-lt".id = "4AGB4CH-53R7AD2-U6YUREI-QXX77WS-IAZ3YWG-T4OBNWN-VQAVA2P-5FNBGAU";
        };
        folders = foldersForThisHost;
      };
      tray.enable = true;
    };
    sops.secrets."syncthing-password" = {
      sopsFile = ../../../secrets/syncthing-password;
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
