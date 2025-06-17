{
  description = "Home Manager configuration of gipphe";

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (_: {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];

      imports = [
        {
          config._module.args._inputs = inputs // {
            inherit (inputs) self;
          };
        }

        inputs.treefmt-nix.flakeModule
      ];

      perSystem =
        {
          inputs',
          config,
          pkgs,
          ...
        }:
        {
          formatter = pkgs.nixfmt-rfc-style;

          devShells.default =
            let
              extra = import ./devShell {
                inherit pkgs config;
                inherit (pkgs) lib;
              };
            in
            inputs'.devshell.legacyPackages.mkShell {
              name = "dotfiles";
              commands = extra.shellCommands;
              env = extra.shellEnv;
              packages =
                [ config.treefmt.build.wrapper ] # treewide formatter
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

          treefmt = {
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
        };

      flake =
        let
          hosts = import ./hosts.nix inputs;
        in
        {
          inherit (hosts)
            darwinConfigurations
            nixOnDroidConfigurations
            nixosConfigurations
            ;
        };
    });

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    haskell-tools-nvim = {
      url = "github:mrcjkb/haskell-tools.nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix/release-25.05";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    nixCats.url = "github:BirdeeHub/nixCats-nvim";

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
