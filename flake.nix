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
      environments = import ./environments inputs;
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
          fluorine-manager = pkgs.callPackage ./packages/fluorine-manager.nix { };
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

      checks = eachSystem (
        { pkgs, system, ... }:
        let
          inherit (pkgs) lib;
          filterSystem = lib.filterAttrs (n: c: c.pkgs.stdenv.hostPlatform.system == system);
          mkNixosCheck = name: x: {
            name = "nixos-${name}";
            value = x.config.system.build.toplevel;
          };
          # mkNixOnDroidCheck = name: x: {
          #   name = "nix-on-droid-${name}";
          #   value = x.activationPackage;
          # };
        in
        lib.pipe self.nixosConfigurations [
          filterSystem
          (lib.mapAttrs' mkNixosCheck)
        ]
        # // lib.pipe self.nixOnDroidConfigurations [
        #   filterSystem
        #   (lib.mapAttrs' mkNixOnDroidCheck)
        # ]
      );

      images.sodium = self.nixosConfigurations.sodium.config.system.build.image;

      inherit (environments)
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

    dolphin-overlay = {
      url = "github:Gipphe/dolphin-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
  };

  nixConfig = {
    extra-substituters = [
      "https://atelier.cachix.org"
      "https://attic.xuyh0120.win/lantian"
      "https://cache.iog.io"
      "https://cache.nixos.org"
      "https://comfyui.cachix.org"
      "https://cuda-maintainers.cachix.org"
      "https://gipphe.cachix.org"
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://nixpkgs-unfree.cachix.org"
      "https://noctalia.cachix.org"
    ];
    extra-trusted-public-keys = [
      "atelier.cachix.org-1:rEyd/Z4TiXZbBVuU/lDnKZ/7WtnFTwJ17OKHGcahVUo="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "comfyui.cachix.org-1:33mf9VzoIjzVbp0zwj+fT51HG0y31ZTK3nzYZAX0rec="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "gipphe.cachix.org-1:GeHkB5yyMQkXYCPJ1FqFl8fbtDe6/aSmS9k8c57GetY="
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };
}
