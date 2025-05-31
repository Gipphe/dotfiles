{
  util,
  config,
  ...
}:
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
        };
        folders = {
          "Autodesk case TF state" = {
            path = "${config.home.homeDirectory}/projects/autodesk-case/infrastructure/terraform.tfstate";
            devices = [ "titanium" ];
          };
        };
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
