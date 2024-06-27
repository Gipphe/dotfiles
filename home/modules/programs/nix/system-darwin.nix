{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.programs.nix.enable {
    environment.variables = {
      FLAKE = "/Users/victor/projects/dotfiles";
    };

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
  };
}
