{ pkgs, lib, ... }:
let
  shellApplicationAsCommand =
    {
      name,
      runtimeInputs ? [ ],
      runtimeEnv ? { },
      text,
    }:
    lib.getExe (
      pkgs.writeShellApplication {
        inherit
          name
          runtimeInputs
          runtimeEnv
          text
          ;
      }
    );
in
{
  shellCommands = [
    # Build
    rec {
      help = "Rebuild the system using nh, darwin-rebuild or home-manager, whichever is applicable";
      name = "sw";
      command = shellApplicationAsCommand {
        inherit name;
        runtimeInputs = with pkgs; [
          nh
          jq
        ];
        text =
          let
          in
          # bash
          ''
            if command -v nixos-rebuild &>/dev/null; then
              nh os switch
            elif command -v nix-on-droid &>/dev/null; then
              hostname=$(jq '.hostname' env.json)
              if test -z "$hostname"; then
                echo 'Found no hostname in env.json' >&2
                exit 1
              fi
              nix-on-droid build --flake "$(pwd)#$${hostname}"
              echo
              nvd diff /run/current-system result
              echo
              nix-on-droid switch --flake "$(pwd)#$${hostname}"
            elif command -v darwin-rebuild &>/dev/null; then
              darwin-rebuild build --flake "$(pwd)"
              echo
              nvd diff /run/current-system result
              echo
              darwin-rebuild switch --flake "$(pwd)"
              rm -f result
            elif command -v home-manager &>/dev/null; then
              nh home switch
            fi
          '';
      };
      category = "build";
    }
    rec {
      help = "Rebuild the system using nh os switch --ask";
      name = "swa";
      command = shellApplicationAsCommand {
        inherit name;
        runtimeInputs = with pkgs; [
          nh
          nvd
        ];
        text = # bash
          ''
            if command -v nixos-rebuild &> /dev/null; then
              nh os switch --ask
            elif command -v nix-on-droid &>/dev/null; then
              hostname=$(jq '.hostname' env.json)
              if test -z "$hostname"; then
                echo 'Found no hostname in env.json' >&2
                exit 1
              fi

              nix-on-droid build --flake "$(pwd)#$${hostname}"

              echo
              nvd diff /run/current-system result
              echo

              echo "Apply the config?"
              read -r -p "[y/N]" -n 1 REPLY
              echo

              case "$REPLY" in
                y|Y) nix-on-droid switch --flake "$(pwd)#$${hostname}" ;;
              esac
              rm -f result
            elif command -v darwin-rebuild &>/dev/null; then
              darwin-rebuild build --flake "$(pwd)"

              echo
              nvd diff /run/current-system result
              echo

              echo "Apply the config?"
              read -r -p "[y/N]" -n 1 REPLY
              echo

              case "$REPLY" in
                y|Y) darwin-rebuild switch --flake "$(pwd)" ;;
              esac
              rm -f result
            else
              echo "This is not a NixOS system" >&2
              exit 1
            fi
          '';
      };
      category = "build";
    }
    rec {
      help = "Rebuild the system using nh os boot";
      name = "boot";
      command = shellApplicationAsCommand {
        inherit name;
        runtimeInputs = [ pkgs.nh ];
        text =
          # bash
          ''
            if command -v nixos-rebuild &> /dev/null; then
              nh os boot
            else
              echo "This is not a NixOS system" >&2
              exit 1
            fi
          '';
      };
      category = "build";
    }

    # Formatting
    rec {
      help = "Format the source tree with treefmt";
      name = "fmt";
      command = shellApplicationAsCommand {
        inherit name;
        runtimeInputs = [ pkgs.treefmt ];
        text =
          # bash
          "treefmt";
      };
      category = "formatter";
    }

    # Utils
    rec {
      help = "Update flake inputs and commit changes";
      name = "update";
      command = shellApplicationAsCommand {
        inherit name;
        runtimeInputs = [ pkgs.git ];
        text =
          # bash
          ''nix flake update && git commit flake.lock -m "chore: update flake inputs"'';
      };
      category = "utils";
    }

    # Nix utils
    rec {
      help = "Track distribution of PR";
      name = "nix:pr";
      command = shellApplicationAsCommand {
        inherit name;
        runtimeInputs = [ pkgs.xdg-utils ];
        text =
          # bash
          ''
            if test "$#" = "0" || test "$1" = "--help"; then
              echo "Usage: nix:pr <pr number>"
              exit 1
            fi
            prg=$(command -v open || command -v xdg-open)
            eval "$prg 'https://nixpk.gs/pr-tracker.html?pr=$1'"
          '';
      };
      category = "nix utils";
    }
    rec {
      help = "View store path sizes";
      name = "nix:du";
      command = shellApplicationAsCommand {
        inherit name;
        text =
          # bash
          "nix path-info -rS /run/current-system | sort -nk2";
      };
      category = "nix utils";
    }

    # Linting
    rec {
      help = "Check .nix files with statix";
      name = "lint:statix";
      command = shellApplicationAsCommand {
        inherit name;
        runtimeInputs = [ pkgs.statix ];
        text =
          # bash
          "statix check";
      };
      category = "lint";
    }
    rec {
      help = "Check .nix files with statix, watching";
      name = "lint:statix:watch";
      command = shellApplicationAsCommand {
        inherit name;
        runtimeInputs = [ pkgs.entr ];
        text =
          # bash
          "find . -type f | entr statix check";
      };
      category = "lint";
    }
    rec {
      help = "Check .nix files with deadnix";
      name = "lint:deadnix";
      command = shellApplicationAsCommand {
        inherit name;
        runtimeInputs = [ pkgs.deadnix ];
        text =
          # bash
          "deadnix --exclude ./modules/system/hardware-configuration/*.nix";
      };
      category = "lint";
    }
    rec {
      help = "Check .nix files with deadnix, watching";
      name = "lint:deadnix:watch";
      command = shellApplicationAsCommand {
        inherit name;
        runtimeInputs = with pkgs; [
          entr
          findutils
        ];
        text =
          # bash
          "find . -type f | entr deadnix --exclude ./modules/system/hardware-configuration/*.nix";
      };
      category = "lint";
    }
  ];

  shellEnv = [
    {
      # make direnv shut up
      name = "DIRENV_LOG_FORMAT";
      value = "";
    }
  ];
}
