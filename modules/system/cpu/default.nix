{ util, ... }:
util.mkSystem {
  name = "cpu";
  system-nixos = {
    services = {
      # Regulates cpu frequencies to reduce battery usage
      auto-cpufreq.enable = true;
      # Recommended to be used with auto-cpufreq
      thermald.enable = true;
      logind.settings.Login = {
        HandleLidSwitchExternalPower = "suspend";
        HandleLidSwitchDocked = "ignore";
      };
      # Must be disabled when using auto-cpufreq
      tlp.enable = false;
    };
  };
}
