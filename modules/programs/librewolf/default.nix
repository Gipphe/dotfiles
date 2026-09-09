{ util, ... }:
util.mkProgram {
  name = "librewolf";
  homeManager = {
    imports = [ ./extensions.nix ];
    programs.librewolf = {
      enable = true;
      policies = {
        DisableTelemetry = true;
        DNSOverHTTPS = {
          ProviderURL = "https://dns.quad9.net/dns-query";
          Fallback = false;
        };
        OfferToSaveLogins = false;
        PasswordManagerEnabled = false;
      };
      profiles.default = {
        settings = import ./settings.nix;
      };
    };
    stylix.targets.librewolf.profileNames = [ "default" ];
  };
}
