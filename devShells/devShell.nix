{
  lib,
  callPackage,

  deadnix,
  entr,
  findutils,
  git,
  gnugrep,
  jq,
  jujutsu,
  nh,
  nil,
  nix,
  statix,
  treefmt,
}:
let
  util = callPackage ../util.nix { };
  cmd = opts: lib.getExe (util.writeFishApplication (opts // { inheritPath = true; }));
  build =
    {
      name,
      command ? "switch",
      ask ? false,
    }:
    cmd {
      inherit name;
      runtimeInputs = [
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
        runtimeInputs = [ nh ];
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
    {
      help = "Format the source tree with treefmt";
      name = "fmt";
      command = lib.getExe treefmt;
      category = "formatter";
    }

    # Utils
    {
      help = "Update flake inputs and commit changes";
      name = "update";
      command =
        # bash
        ''
          ${lib.getExe nix} flake update
          res="$?"
          if test "$res" != 0; then
            exit "$res"
          fi
          if test -d .jj; then
            ${lib.getExe jujutsu} commit flake.lock -m 'chore: update flake inputs'
          else
            ${lib.getExe git} commit flake.lock -m 'chore: update flake inputs'
          fi
        '';
      category = "utils";
    }

    # Nix utils
    {
      help = "Track distribution of PR";
      name = "nix:pr";
      command = # bash
        ''
          if [[ $# == 0 || $* == *--help* || $* == *-h* ]]; then
            echo "Usage: nix:pr <pr number>" >&2
            exit 1
          fi
          pr="$1"
          opener="$(command -v open || command -v xdg-open)"
          if test "$?" != 0; then
            echo "Cannot open link in browser automatically. Copy it yourself:" >&2
            opener="echo"
          fi
          "$opener" "https://nixpk.gs/pr-tracker.html?pr=$pr"
        '';
      category = "nix utils";
    }
    {
      help = "View store path sizes";
      name = "nix:du";
      command = # bash
        ''
          ${lib.getExe nix} path-info -rS /run/current-system | sort -nk2
        '';
      category = "nix utils";
    }

    # Linting
    {
      help = "Check .nix files with nil";
      name = "lint:nil";
      command = # bash
        ''
          ${lib.getExe nil} diagnostics "$( \
            ${lib.getExe git} ls-files | \
            ${lib.getExe gnugrep} '\.nix$' | \
            ${lib.getExe gnugrep} -v 'hardware-configuration/.*\.nix' \
          )"
        '';
      category = "lint";
    }
    {
      help = "Check .nix files with nil, watching";
      name = "lint:nil:watch";
      command = # bash
        ''
          ${lib.getExe git} ls-files | \
            ${lib.getExe gnugrep} '\.nix$' | \
            ${lib.getExe gnugrep} -v 'hardware-configuration/.*\.nix' | \
            ${lib.getExe entr} nil diagnostics /_
        '';
      category = "lint";
    }
    {
      help = "Check .nix files with statix";
      name = "lint:statix";
      command = "${lib.getExe statix} check";
      category = "lint";
    }
    {
      help = "Check .nix files with statix, watching";
      name = "lint:statix:watch";
      command = ''
        ${lib.getExe findutils} . -type f | \
          ${lib.getExe entr} ${lib.getExe statix} check
      '';
      category = "lint";
    }
    {
      help = "Check .nix files with deadnix";
      name = "lint:deadnix";
      command = # bash
        ''
          ${lib.getExe deadnix} --exclude ./modules/system/hardware-configuration/*.nix
        '';
      category = "lint";
    }
    {
      help = "Check .nix files with deadnix, watching";
      name = "lint:deadnix:watch";
      command = # bash
        ''
          ${lib.getExe findutils} . -type f | \
            ${lib.getExe entr} ${lib.getExe deadnix} \
              --exclude ./modules/system/hardware-configuration/*.nix
        '';
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
