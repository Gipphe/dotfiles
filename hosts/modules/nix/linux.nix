{ lib, config, ... }:
{
  imports = [ ./shared.nix ];
  environment.sessionVariables = import ./envVars.nix;

  documentation.dev.enable = false;

  nix = {
    gc.dates = "daily";

    # Make builds run with low priority so my system stays responsive
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };

  # Auto-upgrading with nixos-unstable is risky
  system.autoUpgrade.enable = false;
  system.stateVersion = lib.mkDefault "23.11"; # DON'T TOUCH THIS
}
