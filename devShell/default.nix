{ pkgs, lib, ... }:
let
  util = pkgs.callPackage ../util.nix { };
  cmd = opts: lib.getExe (util.writeFishApplication (opts // { inheritPath = true; }));
  build =
    {
      name,
      command ? "switch",
      ask ? false,
    }:
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
            set -l args ${if ask then "--ask" else ""}

            if command -q nixos-rebuild
              nh os ${command} $args
            else
              nh darwin ${command} $args
            end
          else if command -v nix-on-droid &>/dev/null
            set -l host $(jq '.hostname' env.json)
            if test -z "$host"
              echo 'Found no hostname in env.json' >&2
              exit 1
            end

            nix-on-droid build --flake "$(pwd)#""$host"

            echo
            set -l nixOnDroidPkg $(nix path-info --impure "$NH_FLAKE#nixOnDroidConfigurations.$host.activationPackage")
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
                nix-on-droid switch --flake "$(pwd)#""$host"
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
    rec {
      help = "Test new configuration without saving to bootloader";
      name = "swt";
      command = build {
        inherit name;
        command = "test";
      };
      category = "build";
    }

    rec {
      help = "Test new configuration without saving to bootloader";
      name = "swta";
      command = build {
        inherit name;
        command = "test";
        ask = true;
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
            nix flake update
            or exit $status
            if test -d .jj
              jj commit flake.lock -m 'chore: update flake inputs'
            else
              git commit flake.lock -m 'chore: update flake inputs'
            end
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
      help = "Check .nix files with nil";
      name = "lint:nil";
      command = cmd {
        inherit name;
        runtimeInputs = with pkgs; [
          git
          gnugrep
          nil
        ];
        text = ''
          nil diagnostics $(git ls-files | grep '\.nix$' | grep -v 'hardware-configuration/.*\.nix')
        '';
      };
      category = "lint";
    }
    rec {
      help = "Check .nix files with nil, watching";
      name = "lint:nil:watch";
      command = cmd {
        inherit name;
        runtimeInputs = with pkgs; [
          git
          gnugrep
          nil
          entr
        ];
        text = ''
          git ls-files | grep '\.nix$' | grep -v 'hardware-configuration/.*\.nix' | entr nil diagnostics /_
        '';
      };
      category = "lint";
    }
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
        runtimeInputs = with pkgs; [
          entr
          statix
        ];
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
          deadnix
          findutils
        ];
        text =
          # fish
          "find . -type f | entr deadnix --exclude ./modules/system/hardware-configuration/*.nix";
      };
      category = "lint";
    }

    rec {
      help = "Generate jdenticons for all hosts";
      name = "md:icons";
      command = cmd {
        inherit name;
        runtimeInputs = with pkgs; [
          jdenticon-cli
          findutils
        ];
        text = # fish
          ''
            set hosts (find ./machines/* -maxdepth 0 -type d -exec basename {} \;)
            or begin
              echo "Machines are not here" >&2
              exit 1
            end

            mkdir -p assets/icon

            for host in $hosts
              jdenticon "$host" -s 100 -o "assets/icon/$host.png"
            end
          '';
      };
      category = "docs";
    }

    rec {
      help = "Generate fastfetch output for the current host";
      name = "md:fastfetch";
      category = "docs";
      command = cmd {
        inherit name;
        runtimeInputs = with pkgs; [
          wezterm
          coreutils
          hyprland
          grim
          fastfetch
          unclutter
        ];
        text =
          let
            cfg = pkgs.writeText "fastfetch-config" (
              builtins.toJSON {
                "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
                modules = [
                  "title"
                  "separator"
                  "os"
                  "host"
                  "kernel"
                  # "uptime"
                  "packages"
                  "shell"
                  "display"
                  "de"
                  "wm"
                  "wmtheme"
                  "theme"
                  "icons"
                  "font"
                  "cursor"
                  "terminal"
                  "terminalfont"
                  "cpu"
                  "gpu"
                  "memory"
                  "swap"
                  "disk"
                  # "localip"
                  "battery"
                  "poweradapter"
                  "locale"
                  "break"
                  "colors"
                ];
              }
            );
          in
          ''
            wezterm start --class neofetch --always-new-process -- bash -c 'sleep 1s && fastfetch --config "${cfg}" && read -p ""' &
            sleep 5s

            set -l window (hyprctl clients -j | jq -r '.[] | select(.class == "neofetch")')

            set -l window_pid (echo $window | jq '.pid')
            set -l pos (echo $window | jq -r '.at | (.[0] | tostring) + "," + (.[1] | . + 8 | tostring)')
            # set -l dim (echo $window | jq -r '.size | (.[0] | tostring) + "x" + (.[1] | tostring)')
            set -l dim "900x410"
            set -l g "$pos $dim"

            # Hide the cursor with unclutter
            unclutter -idle 0.1 -root &
            set -l unclutter_pid (jobs --last --pid | tail -n +1)
            sleep 0.5s

            mkdir -p assets/neofetch
            grim -g "$g" "assets/neofetch/$(hostname).png"

            kill $window_pid
            kill $unclutter_pid
          '';
      };
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
