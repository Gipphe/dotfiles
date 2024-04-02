{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  environment = {
    # set channels (backwards compatibility)
    etc = {
      "nix/flake-channels/nixpkgs".source = inputs.nixpkgs;
      "nix/flake-channels/home-manager".source = inputs.home-manager;
    };
  };

  nix = {
    # Clear out the store periodically of old generations
    gc = {
      automatic = true;
      options = "--delete-older-than 10d";
    };
    package = pkgs.nixUnstable;

    # pin the registry to avoid downloading and evaling a new nixpkgs version every time
    registry = lib.mapAttrs (_: v: { flake = v; }) inputs;

    # Free up to 1GiB whenever there is less than 100MiB left
    # extraOptions = ''
    #   keep-outputs = true
    #   warn-dirty = false
    #   keep-derivations = true
    #   min-free = ${toString (100 * 1024 * 1024)}
    #   max-free = ${toString (1024 * 1024 * 1024)}
    # '';
    settings = {
      # Free up to 1GiB whenever there is less than 100MiB left
      keep-outputs = true;
      warn-dirty = false;
      keep-derivations = true;
      min-free = toString (100 * 1024 * 1024);
      max-free = toString (1024 * 1024 * 1024);

      # flake-registry = "/etc/nix/registry.json";
      auto-optimise-store = true;

      # allow sudo users to mark the following values as trusted
      allowed-users = [ "@wheel" ];
      trusted-users = [ "@wheel" ];
      sandbox = true;
      max-jobs = "auto";
      # continue building derivations if one fails
      keep-going = true;
      log-lines = 20;
      extra-experimental-features = [
        "flakes"
        "nix-command"
        "recursive-nix"
        "ca-derivations"
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
  };

  # faster rebuilding
  documentation = {
    enable = true;
    doc.enable = false;
    man.enable = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
    overlays = [
      (_: super: {
        coreutils = super.uutils-coreutils-noprefix;
        coreutils-full = super.uutils-coreutils-noprefix;
        # workaround for: https://github.com/NixOS/nixpkgs/issues/154163
        makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
      })
    ];
  };
}
