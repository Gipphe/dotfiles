{
  lib,
  config,
  pkgs,
  util,
  ...
}:
let
  cfg = config.gipphe.windows.home;
  files = lib.filterAttrs (_: v: v.enable) cfg.file;
  flattenPath = builtins.replaceStrings [ "/" ] [ "-" ];
  vcsConfigs = "${config.gipphe.windows.vcsPath}/windows/configs";
  order = import ./order.nix;
  inherit (import ./helpers.nix { inherit lib; }) toPSVal;
in
util.mkToggledModule [ "windows" ] {
  name = "home";
  options.gipphe.windows.home.file = lib.mkOption {
    description = ''
      Files to write to home directory. Either `text` or `source` are required.
    '';
    type = lib.types.attrsOf (
      lib.types.submodule (
        {
          name,
          config,
          options,
          ...
        }:
        {
          config = {
            source = lib.mkIf (config.text != null) (
              let
                name' = "home-file-" + lib.replaceStrings [ "/" ] [ "-" ] name;
              in
              lib.mkDerivedConfig options.text (pkgs.writeText name')
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
  hm = lib.mkIf (files != { }) {
    gipphe.windows.powershell-script =
      lib.mkOrder order.home # powershell
        ''
          class Config {
            [PSCustomObject]$Logger
            [String]$CfgDir

            Config([PSCustomObject]$Logger, [String]$Dirname) {
              $this.Logger = $Logger
              $this.CfgDir = "$Dirname/configs"
            }

            [Void] Install() {
              $this.Logger.Info(" Copying config files...")
              $ChildLogger = $this.Logger.ChildLogger()
              if ($null -eq $Env:HOME) {
                $Env:HOME = $Env:USERPROFILE
              }
              $HOME = $Env:HOME
              $Items = @(
                ${
                  lib.pipe files [
                    (lib.mapAttrsToList (
                      path: f: ''
                        @("$($this.CfgDir)/${flattenPath path}", "$HOME/${toPSVal path}")
                      ''
                    ))
                    (lib.concatStringsSep "\n")
                  ]
                }
              )

              $Items | ForEach-Object {
                $From = $_[0]
                $To = $_[1]

                # Ensure parent dir exists
                $ToDir = Split-Path -Parent $To
                if (-not (Test-Path -PathType Container $ToDir)) {
                  New-Item -Force -ItemType Directory $ToDir
                }

                # Clean out existing destination if it is a directory. Otherwise, we'll
                # end up copying _into_ the existing directory.
                if (Test-Path -PathType Container $To) {
                  Remove-Item -Recurse -Force $To
                }

                Copy-Item -Force -Recurse -Path $From -Destination $To
                $FileName = Split-Path -Leaf $From
                $ChildLogger.Info(" $FileName copied")
              }

              $this.Logger.Info(" Config files copied.")
            }
          }

          $Config = [Config]::new($Logger, $PSScriptRoot)
          $Config.Install()
        '';
    home.activation.copy-windows-files-to-vcs = lib.hm.dag.entryAfter [ "filesChanged" ] ''
      ${lib.concatStringsSep "\n" (
        lib.mapAttrsToList (
          path: f:
          let
            fileName = lib.pipe "${f.source}" [
              (lib.splitString "-")
              builtins.tail
              (lib.concatStringsSep "-")
            ];
          in
          ''
            mkdir -p "${vcsConfigs}/$(dirname -- '${f.source}')"
            cp -f '${f.source}' '${vcsConfigs}/${fileName}'
          ''
        ) files
      )}
    '';
  };
}
