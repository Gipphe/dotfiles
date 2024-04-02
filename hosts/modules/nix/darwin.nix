{
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [ ./shared.nix ];
  environment.variables = import ./envVars.nix;

  nix = {
    gc.interval = {
      Hour = 3;
      Minute = 0;
    };

    # Make builds run with low priority so my system stays responsive
    # daemonProcessType = "Background";
    # daemonIOLowPriority = true;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: { key = value.to.path; }) config.nix.registry;

    settings = {
      # Nix on darwin experiences issues with too long S-expressions passed to
      # `sandbox-exec`.
      sandbox = false;
      allowed-users = [ "*" ];
      trusted-users = [ "root" ];
    };
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
