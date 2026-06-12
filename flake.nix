{
  description = "Home Manager configuration of gipphe";

  outputs =
    inputs@{
      self,
      treefmt-nix,
      nixpkgs,
      ...
    }:
    let
      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
      eachSystem =
        f:
        nixpkgs.lib.genAttrs systems (
          system:
          f {
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system};
          }
        );
      hosts = import ./hosts inputs;
    in
    {
      formatter = eachSystem ({ system, ... }: self.packages.${system}.treefmt);

      devShells = eachSystem (
        { pkgs, system }:
        {
          default = pkgs.callPackage ./devShells/default.nix {
            inherit (inputs.devshell.legacyPackages.${system}) mkShell;
            inherit (self.packages.${system}) jujutsu;
          };
        }
      );

      packages = eachSystem (
        { pkgs, ... }:
        let
          util = pkgs.callPackage ./util.nix { };
        in
        {
          md-fastfetch = pkgs.callPackage ./packages/md-fastfetch.nix {
            inherit (util) writeFishApplication;
          };
          md-icons = pkgs.callPackage ./packages/md-icons.nix { inherit (util) writeFishApplication; };
          treefmt = pkgs.callPackage ./packages/treefmt.nix { inherit treefmt-nix; };
          mo2installer = pkgs.callPackage ./packages/mo2installer.nix { };
        }
        // (
          let
            x = self.nixosConfigurations.titanium.config.home-manager.users.gipphe.wrappers;
          in
          {
            jujutsu = x.jujutsu.wrapper;
            git = x.git.wrapper;
          }
        )
      );

      checks =
        let
          inherit (nixpkgs) lib;
        in
        {
          "x86_64-linux" = lib.mapAttrs' (name: x: {
            name = "nixos_${name}";
            value = x.config.system.build.toplevel;
          }) (lib.filterAttrs (n: _: n != "boron") self.nixosConfigurations);

          "aarch64-linux" =
            lib.mapAttrs (name: x: {
              name = "nix-on-droid_${name}";
              value = x.activationPackage;
            }) self.nixOnDroidConfigurations
            // self.checks."x86_64-linux";
        };

      images.sodium = self.nixosConfigurations.sodium.config.system.build.image;

      inherit (hosts)
        nixOnDroidConfigurations
        nixosConfigurations
        ;
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    # TODO: Remove this once this issue is resolved:
    # https://github.com/nix-community/nix-on-droid/issues/495
    nixpkgs-last-working-for-nix-on-droid.url = "github:NixOS/nixpkgs/88d3861";

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wlib = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Do not override its nixpkgs input, since it uses bleeding edge versions
    # of specific packages
    nix-gaming.url = "github:fufexan/nix-gaming";

    # Do not override its nixpkgs input, otherwise there can be mismatch
    # between patches and kernel version
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel";

    # Do not override its nixpkgs input, since it uses bleeding edge versions
    # of specific packages
    nix-gaming-edge.url = "github:powerofthe69/nix-gaming-edge";

    # Do not override its nixpkgs input, nixpkgs contains packages that are too
    # up-to-date for comfyui
    comfyui.url = "github:Gipphe/comfyui-nix";

    # Do not override its nixpkgs input, it is configured for specific versions
    # of each of the plugins
    giphtvim.url = "github:Gipphe/giphtvim";

    # Do not override its nixpkgs input, it invalidates the cachix cache, and
    # will probably break things.
    hyprland.url = "github:hyprwm/Hyprland";

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-db = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tricorder.url = "github:atelier-hub/tricorder";

    # TODO: Remove once https://github.com/NixOS/nixpkgs/pull/521906 is in
    # nixos-unstable.
    nixpkgs-sunshine.url = "github:Qubasa/nixpkgs/update_sunshine";
  };
}
