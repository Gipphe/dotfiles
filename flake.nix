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

        inputs.flake-parts.flakeModules.easyOverlay
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
              extra = import ./devShell;
            in
            inputs'.devshell.legacyPackages.mkShell {
              name = "dotfiles";
              commands = extra.shellCommands;
              env = extra.shellEnv;
              packages =
                [
                  inputs'.agenix.packages.default # agenix CLI in flake shell
                  # inputs'.catppuccinifier.packages.cli
                  inputs'.nh.packages.default # better nix CLI
                  config.treefmt.build.wrapper # treewide formatter
                ]
                ++ (with pkgs; [
                  nix-output-monitor # pretty nix output
                  nix-tree
                  entr # run commands on file changes
                  nixfmt-rfc-style # nix formatter
                  git # flake requires git
                  statix # lints and suggestions
                  deadnix # clean up unused nix code
                  nvd # Diff nix results
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
              "system/nixos/hardware-configuration/*.nix"
              "hardware-configuration.nix"
            ];
          };

          packages = {
            tlm = pkgs.callPackage ./home/modules/programs/tlm/package.nix { };
            dataform = pkgs.callPackage ./packages/dataform { };
            dtui = pkgs.callPackage ./packages/dtui { };
          };
        };

      flake = {
        inherit (import ./hosts.nix inputs) nixosConfigurations darwinConfigurations;
      };
    });

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
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

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs-agenix-not-broken";
      };
    };
    nixpkgs-agenix-not-broken.url = "github:nixos/nixpkgs/c00d587b1a1afbf200b1d8f0b0e4ba9deb1c7f0e";

    hyprland = {
      url = "github:hyprwm/Hyprland/";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        hyprlang.follows = "hyprlang";
        systems.follows = "sys-default-linux";
      };
    };

    xdg-portal-hyprland = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        hyprlang.follows = "hyprlang";
        hyprland-protocols.follows = "hyprland-protocols";
        systems.follows = "sys-default-linux";
      };
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        hyprlang.follows = "hyprlang";
        systems.follows = "sys-default-linux";
      };
    };

    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs = {
        hyprlang.follows = "hyprlang";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "sys-default-linux";
      };
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprcontrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprlang = {
      url = "github:hyprwm/hyprlang";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "sys-default-linux";
      };
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

    catppuccinifier = {
      url = "github:lighttigerXIV/catppuccinifier";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
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

    hyprland-protocols = {
      url = "github:hyprwm/hyprland-protocols";
      inputs = {
        systems.follows = "sys-default-linux";
        nixpkgs.follows = "nixpkgs";
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
