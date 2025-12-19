{ util, config, ... }:
util.mkSystem {
  name = "wifi";
  system-nixos = {
    networking = {
      wireless = {
        enable = true;
        userControlled.enable = true;
        iwd.enable = false;
        scanOnLowSignal = false;
        secretsFile = config.sops.secrets.networking-wireless-secrets.path;
        networks = {
          "GiphtNet".pskRaw = "ext:psk_giphtnet";
        };
      };
    };
    sops.secrets.networking-wireless-secrets = {
      format = "binary";
      sopsFile = ../../../secrets/pub-networking-wireless-secrets.txt;
    };
  };
}
