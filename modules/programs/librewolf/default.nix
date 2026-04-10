{ util, ... }:
util.mkProgram {
  name = "librewolf";
  hm = {
    imports = [ ./extensions.nix ];
    programs.librewolf = {
      enable = true;
      policies = {
        DisableTelemetry = true;
        DNSOverHTTPS = {
          ProviderURL = "https://dns.mullvad.net/dns-query";
          Fallback = false;
        };
        OfferToSaveLogins = false;
        PasswordManagerEnabled = false;
      };
    };
  };
}
