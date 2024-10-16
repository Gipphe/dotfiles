{ util, pkgs, ... }:
util.mkToggledModule [ "networking" ] {
  name = "wireguard";
  hm = {
    home.packages = [ pkgs.wireguard-tools ];
    sops.secrets.VNB-MB-Pro-wireguard-key = {
      sopsFile = ../../../secrets/VNB-MB-Pro-wireguard-key.key;
      mode = "400";
      format = "binary";
    };
  };
  system-darwin.homebrew.masApps.Wireguard = 1451685025;
}
