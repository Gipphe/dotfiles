{ util, ... }:
util.mkModule {
  hm.programs.floorp.policies = {
    DisableTelemetry = true;
    DNSOverHTTPS = {
      ProviderURL = "https://dns.mullvad.net/dns-query";
      Fallback = false;
    };
    OfferToSaveLogins = false;
    PasswordManagerEnabled = false;
  };
}
