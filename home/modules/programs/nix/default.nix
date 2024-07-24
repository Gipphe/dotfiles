{
  lib,
  config,
  pkgs,
  inputs,
  util,
  ...
}:
let
  mb = x: x * 1024 * 1024;
in
{
  imports = [
    ./nix-gc

    (util.mkModule {
      options.gipphe.programs.nix.enable = lib.mkEnableOption "nix";

      hm = lib.mkIf config.gipphe.programs.nix.enable { home.packages = [ pkgs.nixVersions.git ]; };

      system-all = lib.mkIf config.gipphe.programs.nix.enable {
        nix = {
          package = pkgs.nixVersions.git;

          # pin the registry to avoid downloading and evaling a new nixpkgs version every time
          registry = lib.mapAttrs (_: v: { flake = v; }) inputs;

          # This will additionally add your inputs to the system's legacy channels
          # Making legacy nix commands consistent as well, awesome!
          nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

          settings = {
            # Free up to 1GiB whenever there is less than 100MiB left
            keep-outputs = true;
            warn-dirty = false;
            keep-derivations = true;
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
            keep-going = true;
            log-lines = 30;
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
      };

      system-darwin = lib.mkIf config.gipphe.programs.nix.enable {
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

      system-nixos = lib.mkIf config.gipphe.programs.nix.enable {
        nix = {
          # Make builds run with low priority so my system stays responsive
          daemonCPUSchedPolicy = "idle";
          daemonIOSchedClass = "idle";
        };
      };
    })
  ];
}
