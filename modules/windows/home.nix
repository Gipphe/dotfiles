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
  vcsConfigs = "${config.gipphe.windows.vcsPath}/windows/configs";
  order = import ./order.nix;
  normalize =
    path:
    builtins.replaceStrings
      [
        "/"
        " "
      ]
      [
        ""
        ""
      ]
      path;
in
util.mkToggledModule [ "windows" ] {
  name = "home";
  options.gipphe.windows.home.file = lib.mkOption {
    description = ''
      Files to write to home directory. Either `text` or `source` are required.
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
              $baseUrl = $Env:USERPROFILE
              $Items = Get-ChildItem -File -Recurse "$($this.CfgDir)" | Resolve-Path -Relative -RelativeBasePath "$($this.CfgDir)"

              $Items | ForEach-Object {
                $From = Resolve-PathNice "$($this.CfgDir)/$_"
                $To = Resolve-PathNice "$baseUrl/$_"

                # Ensure parent dir exists
                $ToDir = Split-Path -Parent $To
                if (-not (Test-Path -PathType Container $ToDir)) {
                  New-Item -Force -ItemType Directory $ToDir
                }

                # Clean out existing destination if it is a directory. Otherwise, we'll
                # end up copying _into_ the existing directory.
                if (Test-Path -PathType Container $To) {
                  Write-Host "Would have deleted $To because it is a directory"
                  continue
                  # Remove-Item -Recurse -Force $To
                }

                Copy-Item -Force -Recurse -Path $From -Destination $To
                $FileName = Split-Path -Leaf $From
                $ChildLogger.Info(" $_ copied")
              }

              $this.Logger.Info(" Config files copied.")
            }
          }

          $Config = [Config]::new($Logger, $PSScriptRoot)
          $Config.Install()
        '';

    home.activation = (
      lib.mapAttrs' (path: v: {
        name = "copy-windows-file-${normalize path}";
        value =
          lib.hm.dag.entryAfter [ "filesChanged" ] # bash
            ''
              run mkdir -p "$(dirname -- '${vcsConfigs}/${path}')"
              run cp -Lf '${v.source}' '${vcsConfigs}/${path}'
            '';
      }) files
    );
  };
}
