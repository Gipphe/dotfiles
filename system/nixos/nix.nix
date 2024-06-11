{ lib, config, ... }:
{
  programs.nh = {
    enable = true;
    flake = "/home/gipphe/projects/dotfiles";
    clean = {
      enable = true;
      extraArgs = "--keep 5 --keep-since 5d";
    };
  };

  environment.sessionVariables = {
    # Set default flake path for nh
    FLAKE = "/home/gipphe/projects/dotfiles";
  };

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
