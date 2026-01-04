{
  lib,
  writeShellApplication,

  deadnix,
  entr,
  findutils,
  gitMinimal,
  gnugrep,
  jq,
  jujutsu,
  nh,
  nil,
  nix,
  nvd,
  statix,
  treefmt,
}:
let
  build =
    let
      script = writeShellApplication {
        name = "switch-build";
        runtimeInputs = [
          nh
          jq
          nvd
        ];
        text = builtins.readFile ./build.sh;
      };
    in
    lib.getExe script;
in
{
  shellCommands = [
    # Build
    {
      help = "Rebuild NixOS or nix-on-droid system.";
      name = "sw";
      command = ''
        ${build} switch
      '';
      category = "build";
    }
    {
      help = "Rebuild NixOS or nix-on-droid system, asking first.";
      name = "swa";
      command = ''
        ${build} switch --ask
      '';
      category = "build";
    }
    {
      help = "Rebuild the system using nh os boot";
      name = "boot";
      command =
        # bash
        ''
          if command -v nixos-rebuild &>/dev/null; then
            ${lib.getExe nh} os boot
          else
            echo "This is not a NixOS system" >&2
            exit 1
          fi
        '';
      category = "build";
    }
    {
      help = "Test new configuration without saving to bootloader";
      name = "swt";
      command = ''
        ${build} test
      '';
      category = "build";
    }

    {
      help = "Test new configuration without saving to bootloader";
      name = "swta";
      command = ''
        ${build} test --ask
      '';
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
            ${lib.getExe gitMinimal} commit flake.lock -m 'chore: update flake inputs'
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
          mapfile -t files < <( \
            ${lib.getExe gitMinimal} ls-files | \
            ${lib.getExe gnugrep} '\.nix$' | \
            ${lib.getExe gnugrep} -v 'hardware-configuration/.*\.nix' | \
            ${lib.getExe gnugrep} -v 'hardware-configuration\.nix$' \
          )
          for file in "''${files[@]}"; do
            ${lib.getExe nil} diagnostics "$file"
          done
        '';
      category = "lint";
    }
    {
      help = "Check .nix files with nil, watching";
      name = "lint:nil:watch";
      command = # bash
        ''
          ${lib.getExe gitMinimal} ls-files | \
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
          ${lib.getExe deadnix} --exclude ./machines/*/hardware-configuration.nix
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
