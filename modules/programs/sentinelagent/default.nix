{
  inputs,
  util,
  config,
  pkgs,
  ...
}:
util.mkProgram {
  name = "sentinelagent";
  system-nixos = {
    imports = [ inputs.sentinelone.nixosModules.sentinelone ];
    services.sentinelone = {
      enable = true;
      sentinelOneManagementTokenPath = config.sops.secrets.utv-vnb-lt-sentinelagent-token.path;
      email = "vnb@lovdata.no";
      serialNumber = "2Q2C594";
      package = inputs.sentinelone.packages.${pkgs.system}.sentinelone.overrideAttrs (old: {
        version = "24.2.2.20";
        src = pkgs.fetchurl {
          url = "https://databra007.se/s1/SentinelAgent_linux_x86_64_v24_2_2_20.deb";
          hash = "";
        };
      });
    };
    sops.secrets.utv-vnb-lt-sentinelagent-token = {
      format = "binary";
      sopsFile = ../../../secrets/utv-vnb-lt-sentinelagent-token;
    };
  };
}
