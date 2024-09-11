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

        inputs.pre-commit-hooks.flakeModule
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
          formatter = pkgs.nixfmt;

          pre-commit = {
            settings.excludes = [ "flake.lock" ];

            settings.hooks = {
              nixfmt.enable = true;
              prettier.enable = true;
            };
          };
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

          packages = {
            tlm = pkgs.callPackage ./modules/programs/tlm/package.nix { };
          };
        };

      flake = {
        inherit (import ./hosts.nix inputs) nixosConfigurations darwinConfigurations;
      };
    });

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
    };

    neovim-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        flake-compat.follows = "flake-compat";
      };
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
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

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        devshell.follows = "devshell";
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        nix-darwin.follows = "darwin";
        home-manager.follows = "home-manager";
      };
    };

    wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
    };

    haskell-tools-nvim = {
      url = "github:mrcjkb/haskell-tools.nvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
    };

    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        flake-compat.follows = "flake-compat";
      };
    };

    mac-app-util.url = "github:hraban/mac-app-util";

    brew-nix = {
      url = "github:BatteredBunny/brew-nix";
      inputs = {
        brew-api.follows = "brew-api";
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        nix-darwin.follows = "darwin";
      };
    };

    brew-api = {
      url = "github:BatteredBunny/brew-api";
      flake = false;
    };

    flake-compat.url = "github:edolstra/flake-compat";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "sys-default";
    sys-default-linux.url = "github:nix-systems/default-linux";
    sys-default.url = "github:nix-systems/default";
  };
}
