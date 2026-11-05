{
  lib,
  writeNushellApplication,
  mkShell,

  libnotify,
  cachix,
  comma,
  jujutsu,
  nh,
  nix-tree,
  nixfmt,
  nvd,

  sopsSecrets,
}:
let
  build =
    let
      script = writeNushellApplication {
        name = "switch-build";
        runtimeInputs = [
          cachix
          libnotify
          nh
          nvd
        ];
        runtimeEnv.CACHIX_TOKEN_FILE_PATH = sopsSecrets."pub/cachix-gipphe-token.txt".path;
        text = /* nu */ ''
          use ${./.}/build.nu
          def --wrapped main [...args]: nothing -> nothing {
            build ...($args)
          }
        '';
      };
    in
    lib.getExe script;
  commandToPackage =
    command:
    if command ? package && lib.isDerivation command.package then
      command.package
    else
      writeNushellApplication {
        inherit (command) name;
        text = command.command;
      };
  mkShell' =
    {
      name,
      commands,
      env,
      packages,
    }:
    mkShell {
      inherit name;
      packages = packages ++ map commandToPackage commands ++ [ (menu commands) ];
      shellHook = ''
        ${builtins.concatStringsSep "\n" (
          map ({ name, value }: "export ${name}=${lib.escapeShellArg value}") env
        )}

        menu
      '';
    };
  menu =
    commands:
    writeNushellApplication {
      name = "menu";
      runtimeEnv.commands = builtins.toJSON (map (c: { inherit (c) name category help; }) commands);
      text = builtins.readFile ./menu.nu;
    };
in
mkShell' {
  name = "dotfiles";
  commands = [
    # Build
    {
      help = "Rebuild NixOS or nix-on-droid system.";
      name = "sw";
      command = /* nu */ ''
        ${build} switch
      '';
      category = "build";
    }
    {
      help = "Rebuild NixOS or nix-on-droid system, asking first.";
      name = "swa";
      command = /* nu */ ''
        ${build} switch --ask
      '';
      category = "build";
    }
    {
      help = "Rebuild the system using nh os boot";
      name = "boot";
      package = writeNushellApplication {
        name = "boot";
        text = /* nu */ ''
          if (which nixos-rebuild | length | $in > 0) {
            nh os boot
          } else {
            error make "This is not a NixOS system"
          }
        '';
      };
      category = "build";
    }
    {
      help = "Test new configuration without saving to bootloader";
      name = "swt";
      command = /* nu */ ''
        ${build} test
      '';
      category = "build";
    }

    {
      help = "Test new configuration without saving to bootloader, asking first";
      name = "swta";
      command = /* bash */ ''
        ${build} test --ask
      '';
      category = "build";
    }

    # Utils
    {
      help = "Update flake inputs and commit changes";
      name = "update";
      command = /* nu */ ''
        nix flake update
        jujutsu commit flake.lock -m 'chore: update flake inputs'
      '';
      category = "utils";
    }

    # Nix utils
    {
      help = "Track distribution of PR";
      name = "nix:pr";
      package = writeNushellApplication {
        name = "nix:pr";
        text = /* nu */ ''
          # Check which nixpkgs branches a given PR has been deployed to.
          def main [
            pr_number: int # PR to check.
          ] {
            start $"https://nixpk.gs/pr-tracker.html?pr=($pr_number)"
          }
        '';
      };
      category = "nix utils";
    }
    {
      help = "View store path sizes";
      name = "nix:du";
      command = /* nu */ ''
        (
          nix path-info -rS /run/current-system
            | lines
            | each {
              split column --regex '\s+' path size | get 0
            }
            | update size { into filesize }
            | sort-by --reverse size
            | explore
        )
      '';
      category = "nix utils";
    }

    # Linting
    {
      help = "Check .nix files with nil";
      name = "lint:nil";
      package = writeNushellApplication {
        name = "lint:nil";
        text = /* nu */ ''
          for file in (glob --exclude ['**/_hardware-configuration.nix'] **/*.nix) {
            , nil diagnostics --deny-warnings $file
          }
        '';
      };
      category = "lint";
    }
    {
      help = "Check .nix files with statix";
      name = "lint:statix";
      command = /* nu */ ''
        , statix check
      '';
      category = "lint";
    }
    {
      help = "Check .nix files with deadnix";
      name = "lint:deadnix";
      command = /* nu */ ''
        , deadnix
      '';
      category = "lint";
    }
  ];

  env = [
    {
      # make direnv shut up
      name = "DIRENV_LOG_FORMAT";
      value = "";
    }
    {
      name = "NH_SHOW_ACTIVATION_LOGS";
      value = "true";
    }
  ];

  packages = [
    cachix
    comma
    nix-tree
    nixfmt # nix formatter
    jujutsu
    nh
  ];
}
