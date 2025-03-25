args@{
  lib,
  pkgs,
  config,
  ...
}:
let
  util = import ./util.nix args;
  cfg = config.windows;
in
{
  options.windows = {
    destination = lib.mkOption {
      description = ''
        Where to put the final machine configuration JSONs, relative to $HOME.

        This uses `home.file` under the hood to write the final JSONs.
      '';
      type = lib.types.str;
      example = "projects/dotfiles/windows/profiles/";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      description = "Hostname for the Windows machine";
    };

    vcsPath = lib.mkOption {
      description = ''
        Path to VCS repo for this configuration. Used to find a spot for files
        that have to be committed into VCS to be carried over to Windows.
      '';
      type = lib.types.str;
      example = "$${config.gipphe.homeDirectory}/projects/dotfiles";
    };

    configuration = {
      enable = lib.mkEnableOption "Windows profile";

      chocolatey = {
        programs = lib.mkOption {
          description = "Programs to add from Chocolatey.";
          type =
            with lib.types;
            listOf (oneOf [
              str
              (submodule {
                options = {
                  name = lib.mkOption {
                    description = "Name of the package.";
                    type = str;
                  };
                  args = lib.mkOption {
                    description = "Arguments to pass to `choco install`.";
                    type = str;
                  };
                };
              })
            ]);
          default = [ ];
          example = [
            "vscode"
            "Everything"
          ];
        };
      };

      environment = {
        variables = lib.mkOption {
          description = "Environment variables";
          type =
            with lib.types;
            attrsOf (oneOf [
              str
              (submodule {
                options = {
                  enable = lib.mkOption {
                    description = "Whether to set the environment variable or not.";
                    type = bool;
                    default = true;
                  };
                  value = lib.mkOption {
                    description = "Value of the environment variable";
                    type = oneOf [
                      str
                      rawType
                    ];
                  };
                };
              })
            ]);
          default = { };
        };
      };

      home = {
        download = lib.mkOption {
          description = ''
            Files to download and write to home directory. Attrset where
            keys represent destination path and values represent download
            URLs.
          '';
          type = with lib.types; attrsOf str;
        };
        file = lib.mkOption {
          description = ''
            Files to write to home directory. Either `text` or `source`
            are required.
          '';
          type = lib.types.attrsOf (
            lib.types.submodule (
              { name, config, ... }:
              {
                config = {
                  source = lib.mkIf (config.text != null) (
                    lib.mkDefault (
                      pkgs.writeTextFile {
                        inherit (config) text;
                        name = util.storeFileName "win_" name;
                      }
                    )
                  );
                };
                options = {
                  enable = lib.mkOption {
                    description = ''
                      Whether this $HOME file should be generated.
                    '';
                    type = lib.types.bool;
                    default = true;
                  };
                  text = lib.mkOption {
                    description = ''
                      Text contents of the file.
                    '';
                    type = lib.types.nullOr lib.types.lines;
                    default = null;
                  };
                  source = lib.mkOption {
                    description = ''
                      Path to the source file.
                    '';
                    type = lib.types.path;
                  };
                };
              }
            )
          );
        };
      };

      programs = {
        manual = lib.mkOption {
          description = "Programs to install manually from an installer.";
          type =
            with lib.types;
            attrsOf (submodule {
              options = {
                enable = lib.mkOption {
                  description = "Install this program.";
                  type = bool;
                  default = true;
                };
                stampName = lib.mkOption {
                  description = ''
                    Name of the stamp used to record the installation
                    state of this program.
                  '';
                  type = str;
                };
                url = lib.mkOption {
                  description = "URL for the installer.";
                  type = str;
                };
              };
            });
          default = { };
          example = {
            "Firefox Developer Edition" = {
              stampName = "install-firefox-developer-edition";
              url = "https://download-installer.cdn.mozilla.net/pub/devedition/releases/120.0b4/win32/en-US/Firefox%20Installer.exe";
            };
          };
        };
      };

      registry = {
        enableAutoLogin = lib.mkOption {
          description = ''
            Automatically log into an account. The prompts for account
            credentials when the script is ran.
          '';
          type = lib.types.bool;
          default = true;
        };
        entries = lib.mkOption {
          description = "Registry entries to add.";
          default = [ ];
          type =
            with lib.types;
            listOf (submodule {
              options = {
                enable = lib.mkOption {
                  description = "Whether to enable management of the entry.";
                  type = bool;
                  default = true;
                };
                description = lib.mkOption {
                  description = "Description for the registry entry and its effect.";
                  type = lines;
                };
                path = lib.mkOption {
                  description = "Registry path to write the entry to.";
                  type = str;
                };
                entry = lib.mkOption {
                  description = "Name of the entry to write.";
                  type = str;
                };
                type = lib.mkOption {
                  description = "Entry type.";
                  type = str;
                };
                data = lib.mkOption {
                  description = "Entry data.";
                  type = anything;
                };
              };
            });
        };
      };

      scoop = {
        buckets = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = ''
            Additional buckets to add.
          '';
          default = [ ];
          example = [ "extras" ];
        };
        programs = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = ''
            Programs to add from Scoop.
          '';
          default = [ ];
          example = [ "direnv" ];
        };
      };

      sd.enable = lib.mkEnableOption "SD configuration";

      wsl.enable = lib.mkEnableOption "WSL configuration";
    };
  };

  config = {
    home.activation.write-windows-configuration =
      let
        pkg = pkgs.writeText "windows-configuration-${cfg.hostname}" (builtins.toJSON cfg.configuration);
      in
      lib.hm.dag.entryAfter [ "onFilesChange" ] ''
        run mkdir -p '${cfg.destination}'
        run cp -f '${pkg}' '${cfg.destination}/${cfg.hostname}.json'
      '';
  };
}
