{ pkgs, lib, ... }:
let
  util = pkgs.callPackage ../util.nix { };
  cmd = opts: lib.getExe (util.writeFishApplication (opts // { inheritPath = true; }));
  build =
    { name, ask }:
    cmd {
      inherit name;
      runtimeInputs = with pkgs; [
        nh
        jq
      ];
      text =
        # fish
        ''
          if command -q nixos-rebuild || command -q darwin-rebuild
            set -l args
            if test '${builtins.toString ask}' = 'true'
              set -a args '--ask'
            end

            if command -q nixos-rebuild
              nh os switch $args
            else
              nh darwin switch $args
            end
          else if command -v nix-on-droid &>/dev/null
            set -l hostname $(jq '.hostname' env.json)
            if test -z "$hostname"
              echo 'Found no hostname in env.json' >&2
              exit 1
            end

            nix-on-droid build --flake "$(pwd)#""$hostname"

            echo
            set -l nixOnDroidPkg $(nix path-info --impure "$NH_FLAKE#nixOnDroidConfigurations.$hostname.activationPackage")
            nvd diff "$nixOnDroidPkg" result
            echo

            set -l REPLY
            if test '${builtins.toString ask}' = 'true'
              echo "Apply the config?"
              read -r -p "[y/N]" -n 1 REPLY
              echo
            else
              set REPLY y
            end

            switch "$(string lower $REPLY)"
              case y
                nix-on-droid switch --flake "$(pwd)#""$hostname"
            end
            rm -f result
          else
            echo "This is not a NixOS, nix-darwin or nix-on-droid system" >&2
            exit 1
          end
        '';
    };
in
{
  shellCommands = [
    # Build
    rec {
      help = "Rebuild NixOS, nix-darwin or nix-on-droid system.";
      name = "sw";
      command = build {
        inherit name;
        ask = false;
      };
      category = "build";
    }
    rec {
      help = "Rebuild NixOS, nix-darwin or nix-on-droid system, asking first.";
      name = "swa";
      command = build {
        inherit name;
        ask = true;
      };
      category = "build";
    }
    rec {
      help = "Rebuild the system using nh os boot";
      name = "boot";
      command = cmd {
        inherit name;
        runtimeInputs = [ pkgs.nh ];
        text =
          # fish
          ''
            if command -q nixos-rebuild
              nh os boot
            else
              echo "This is not a NixOS system" >&2
              exit 1
            end
          '';
      };
      category = "build";
    }

    # Formatting
    rec {
      help = "Format the source tree with treefmt";
      name = "fmt";
      command = cmd {
        inherit name;
        runtimeInputs = [ pkgs.treefmt ];
        text =
          # fish
          "treefmt";
      };
      category = "formatter";
    }

    # Utils
    rec {
      help = "Update flake inputs and commit changes";
      name = "update";
      command = cmd {
        inherit name;
        runtimeInputs = [ pkgs.git ];
        text =
          # fish
          ''
            nix flake update && git commit flake.lock -m "chore: update flake inputs"
          '';
      };
      category = "utils";
    }

    # Nix utils
    rec {
      help = "Track distribution of PR";
      name = "nix:pr";
      command = cmd {
        inherit name;
        runtimeInputs = [ pkgs.xdg-utils ];
        text =
          # fish
          ''
            if test "$(count $argv)" = "0" || test $argv[1] = "--help"
              echo "Usage: nix:pr <pr number>"
              exit 1
            end
            set -l prg $(command -s open || command -s xdg-open)
            eval "$prg 'https://nixpk.gs/pr-tracker.html?pr="$argv[1]\'
          '';
      };
      category = "nix utils";
    }
    rec {
      help = "View store path sizes";
      name = "nix:du";
      command = cmd {
        inherit name;
        text =
          # fish
          ''
            nix path-info -rS /run/current-system | sort -nk2
          '';
      };
      category = "nix utils";
    }

    # Linting
    rec {
      help = "Check .nix files with statix";
      name = "lint:statix";
      command = cmd {
        inherit name;
        runtimeInputs = [ pkgs.statix ];
        text =
          # fish
          "statix check";
      };
      category = "lint";
    }
    rec {
      help = "Check .nix files with statix, watching";
      name = "lint:statix:watch";
      command = cmd {
        inherit name;
        runtimeInputs = [ pkgs.entr ];
        text =
          # fish
          "find . -type f | entr statix check";
      };
      category = "lint";
    }
    rec {
      help = "Check .nix files with deadnix";
      name = "lint:deadnix";
      command = cmd {
        inherit name;
        runtimeInputs = [ pkgs.deadnix ];
        text =
          # fish
          "deadnix --exclude ./modules/system/hardware-configuration/*.nix";
      };
      category = "lint";
    }
    rec {
      help = "Check .nix files with deadnix, watching";
      name = "lint:deadnix:watch";
      command = cmd {
        inherit name;
        runtimeInputs = with pkgs; [
          entr
          findutils
        ];
        text =
          # fish
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
