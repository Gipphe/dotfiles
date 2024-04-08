{
  description = "Home Manager configuration of gipphe";

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { withSystem, ... }:
      {
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
            formatter = pkgs.nixfmt-rfc-style;

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
                packages = with pkgs; [
                  inputs'.agenix.packages.default # agenix CLI in flake shell
                  inputs'.catppuccinifier.packages.cli
                  inputs'.nh.packages.default # better nix CLI
                  config.treefmt.build.wrapper # treewide formatter
                  entr
                  nixfmt-rfc-style # nix formatter
                  git # flake requires git
                  glow # markdown viewer
                  statix # lints and suggestions
                  deadnix # clean up unused nix code
                ];
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

              settings.formatter.nixfmt-rfc-style.excludes = [ "hardware-configuration.nix" ];
            };
          };

        flake = {
          inherit (import ./hosts inputs) nixosConfigurations darwinConfigurations homeConfigurations;
          images.iapetus =
            (self.nixosConfigurations.iapetus.extendModules {
              modules = [
                "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel-no-zfs-installer.nix"
              ];
            }).config.system.build.sdImage;
        };
      }
    );

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

    impermanence.url = "github:nix-community/impermanence";

    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # project shells
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    schizofox = {
      url = "github:schizofox/schizofox";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        nixpak.follows = "nixpak";
      };
    };

    neovim-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    schizosearch = {
      url = "github:sioodmy/schizosearch";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        home-manager.follows = "home-manager";
      };
    };

    barbie = {
      url = "github:sioodmy/barbie";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    # a tree-wide formatter
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
        darwin.follows = "darwin";
      };
    };

    hyprland = {
      url = "github:hyprwm/Hyprland/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xdg-portal-hyprland = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprcontrib = {
      url = "github:hyprwm/contrib";
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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccinifier = {
      url = "github:lighttigerXIV/catppuccinifier";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
