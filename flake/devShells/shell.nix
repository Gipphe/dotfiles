{
  lib,
  writeNushellApplication,
  mkShell,

  comma,
  jujutsu,
  nh,
  nix-tree,
  nixfmt,
  nvd,
  sops,
}:
let
  build =
    let
      script = writeNushellApplication {
        name = "switch-build";
        runtimeInputs = [
          nh
          nvd
        ];
        text = builtins.readFile ./build.nu;
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
      text = /* nu */ ''
        def intersperse []: list -> list {
          each { [null, $in] } | update 0 first | flatten
        }
        let category_commands = ($env.commands | from json | group-by category)
        [ $"(ansi yellow)dotfiles(ansi reset)", { menu: 'Show this menu' }]
          | table --collapse --index false --theme none
          | print
        $category_commands
          | items { |cat, comms|
              [
                $"(ansi yellow)($cat)(ansi reset)"
                ($comms
                  | select name help
                  | each { { $in.name: $in.help } }
                  | into record
                )
              ]
          }
          | each { |r|
            print ""
            $r | table --collapse --index false --theme none | print
          }
        null
      '';
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
          def main [pr_number: int] {
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
          (glob --exclude ['**/hardware-configuration.nix', '**/hardware-configuration/*.nix'] **/*.nix
            | each { , nil diagnostics $in }
          )
        '';
      };
      category = "lint";
    }
    {
      help = "Check .nix files with statix";
      name = "lint:statix";
      command = /* nu */ ", statix check";
      category = "lint";
    }
    {
      help = "Check .nix files with deadnix";
      name = "lint:deadnix";
      command = /* nu */ ''
        , deadnix --exclude ./hosts/*/hardware-configuration.nix
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
    comma
    nix-tree
    nixfmt # nix formatter
    sops
    jujutsu
    nh
  ];
}
