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
      hosts = import ./hosts.nix inputs;
    in
    {
      formatter = eachSystem ({ system, ... }: self.packages.${system}.treefmt);

      devShells = eachSystem (
        { pkgs, system }:
        {
          default = pkgs.callPackage ./devShells/default.nix {
            inherit (inputs.devshell.legacyPackages.${system}) mkShell;
            inherit (self.packages.${system}) treefmt;
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
          minecraftia-font = pkgs.callPackage ./packages/minecraftia.nix { };
          monocraft-no-ligatures-font = pkgs.callPackage ./packages/monocraft-no-ligatures.nix { };
          treefmt = pkgs.callPackage ./packages/treefmt.nix { inherit treefmt-nix; };
        }
      );

      checks = eachSystem (
        { pkgs, ... }:
        let
          inherit (pkgs) lib;
        in
        lib.mapAttrs' (name: x: {
          name = "nixos_${name}";
          value = x.config.system.build.toplevel;
        }) (lib.filterAttrs (n: _: n != "boron") self.nixosConfigurations)
        # // lib.mapAttrs (name: x: {
        #   name = "nix-on-droid_${name}";
        #   value = x.activationPackage;
        # }) self.nixOnDroidConfigurations
      );

      inherit (hosts)
        nixOnDroidConfigurations
        nixosConfigurations
        ;
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixCats-nvim = {
      url = "github:Gipphe/nixCats-nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      # Do _not_ follow nixpkgs for this flake's nixpkgs input! It invalidates
      # the cachix cache, and will probably break things.
    };

    niri = {
      url = "github:sodiboo/niri-flake";
    };

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    haskell-tools-nvim = {
      url = "github:mrcjkb/haskell-tools.nvim";
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

    wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/quickshell/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    solaar = {
      url = "github:Svenum/Solaar-Flake/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    walker = {
      url = "github:abenz1267/walker";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
