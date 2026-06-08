{
  lib,
  config,
  inputs,
  util,
  ...
}:
let
  mb = x: x * 1024 * 1024;
  nix = {
    # pin the registry to avoid downloading and evaling a new nixpkgs version every time
    registry = lib.mapAttrs (_: v: { flake = v; }) (lib.filterAttrs (x: _: x != "self") inputs);

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };
in
util.mkModule {
  options.gipphe.programs.nix.enable = lib.mkEnableOption "nix";
  shared.imports = [ ./nix-gc ];

  nixos = lib.mkIf config.gipphe.programs.nix.enable {
    sops.secrets.nix-github-api-access-config = {
      format = "binary";
      sopsFile = ../../../secrets/pub-nix-github-api-token-config.txt;
    };
    nix = lib.mkMerge [
      nix
      {
        # Disable generating channel-related files and commands
        channel.enable = false;
        # Make builds run with low priority so my system stays responsive
        daemonCPUSchedPolicy = "idle";
        daemonIOSchedClass = "idle";
        settings = {
          min-free = toString (mb 100);
          max-free = toString (mb 1024);

          flake-registry = "/etc/nix/registry.json";
          auto-optimise-store = true;

          # allow sudo users to mark the following values as trusted
          allowed-users = [ "@wheel" ];
          trusted-users = [ "@wheel" ];
          sandbox = lib.mkDefault true;
          max-jobs = "auto";

          # continue building derivations if one fails
          # keep-going = true;
          log-lines = 30;
          extra-experimental-features = [
            "flakes"
            "nix-command"
          ];

          # use binary cache, its not gentoo
          builders-use-substitutes = true;
          substituters = [
            "https://cache.nixos.org"
            "https://nix-community.cachix.org"
            "https://nixpkgs-unfree.cachix.org"
          ];
          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
          ];
        };

        extraOptions = ''
          !include ${config.sops.secrets.nix-github-api-access-config.path}
        '';
      }
    ];

    nixpkgs.config.allowUnfree = true;
  };

  nixOnDroid = {
    nix = lib.mkMerge [
      nix
      {
        extraOptions = ''
          experimental-features = nix-command flakes ca-derivations
        '';
      }
    ];
  };
}
