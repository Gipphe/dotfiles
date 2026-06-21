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
          ProviderURL = "https://dns.mullvad.net/dns-query";
          Fallback = false;
        };
        OfferToSaveLogins = false;
        PasswordManagerEnabled = false;
      };
      profiles.default = { };
    };
    stylix.targets.librewolf.profileNames = [ "default" ];
  };
  shared.gipphe.nixpkgs.config.permittedInsecurePackages = [
    "librewolf-151.0.2-1"
    "librewolf-unwrapped-151.0.2-1"
  ];
}
