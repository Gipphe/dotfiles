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
        "aarch64-darwin"
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
          default =
            let
              extra = import ./devShell {
                inherit pkgs;
                inherit (pkgs) lib;
              };
            in
            inputs.devshell.legacyPackages.${system}.mkShell {
              name = "dotfiles";
              commands = extra.shellCommands;
              env = extra.shellEnv;
              packages = [
                self.packages.${system}.treefmt
              ] # treewide formatter
              ++ (with pkgs; [
                nh # better nix CLI
                nix-output-monitor # pretty nix output
                nix-tree
                entr # run commands on file changes
                nixfmt-rfc-style # nix formatter
                git # flake requires git
                statix # lints and suggestions
                deadnix # clean up unused nix code
                nvd # Diff nix results
                sops
                vulnix # Vulnerability scanner
              ]);
            };
        }
      );

      packages = eachSystem (
        { pkgs, ... }:
        {
          minecraftia-font = pkgs.callPackage ./packages/minecraftia.nix { };
          monocraft-no-ligatures-font = pkgs.callPackage ./packages/monocraft-no-ligatures.nix { };
          treefmt = treefmt-nix.lib.mkWrapper pkgs {
            projectRootFile = "flake.nix";

            programs = {
              nixfmt-rfc-style.enable = true;
              black.enable = true;
              deadnix.enable = false;
              shellcheck.enable = true;
              shfmt.enable = true;
            };

            settings.formatter.nixfmt-rfc-style.excludes = [
              "root/modules/system/hardware-configuration/*.nix"
              "hardware-configuration.nix"
            ];
          };
        }
      );

      inherit (hosts)
        darwinConfigurations
        nixOnDroidConfigurations
        nixosConfigurations
        ;
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixCats.url = "github:BirdeeHub/nixCats-nvim";

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
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sentinelone = {
      url = "github:devusb/sentinelone-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    solaar = {
      url = "github:Svenum/Solaar-Flake/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    openconnect-sso = {
      url = "github:jcszymansk/openconnect-sso";
      inputs.nixpkgs.follows = "nixpkgs-openconnect-sso";
    };
    nixpkgs-openconnect-sso.url = "github:nixos/nixpkgs/46397778ef1f73414b03ed553a3368f0e7e33c2f";

    # MacOS inputs

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-app-util.url = "github:hraban/mac-app-util";

    brew-nix = {
      url = "github:BatteredBunny/brew-nix";
      inputs = {
        brew-api.follows = "brew-api";
        nixpkgs.follows = "nixpkgs";
        nix-darwin.follows = "darwin";
      };
    };

    brew-api = {
      url = "github:BatteredBunny/brew-api";
      flake = false;
    };
  };
}
