{
  util,
  config,
  inputs,
  ...
}:
util.mkToggledModule [ "lovdata" ] {
  name = "sentinelone";
  system-nixos = {
    imports = [ inputs.lovdata.nixosModules.sentinelone ];

    lovdata.sentinelone = {
      enable = true;
      customerId = "vnb@lovdata.no-2Q2C594";
      sentinelOneManagementTokenPath = config.sops.secrets.utv-vnb-lt-sentinelagent-token.path;
    };

    sops.secrets.utv-vnb-lt-sentinelagent-token = {
      format = "binary";
      sopsFile = ../../../secrets/utv-vnb-lt-sentinelagent-token;
    };
  };
}
