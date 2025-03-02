{ lib, util, ... }:
let
  inherit (import ./util.nix { inherit lib; }) profileOpt;
  order = import ./order.nix;
in
util.mkToggledModule [ "windows" ] {
  name = "scoop";

  options.gipphe.windows.profiles = profileOpt {
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
  };

  hm.gipphe.windows.powershell-script =
    lib.mkOrder order.scoop # powershell
      ''
        class Scoop {
          [PSCustomObject]$Logger

          Scoop([PSCustomObject]$Logger) {
            $this.Logger = $Logger
            $this.EnsureInstalled()
          }

          [Void] EnsureInstalled() {
            try {
              Get-Command "scoop" -ErrorAction Stop
            } catch {
              Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
              Invoke-RestMethod -Uri "https://get.scoop.sh" | Invoke-Expression
            }
          }

          [Void] InstallApps() {
            $this.Logger.Info(" Installing scoop programs...")
            $ChildLogger = $this.Logger.ChildLogger()
            $InstalledBuckets = Invoke-Native { scoop bucket list 6>$Null } | ForEach-Object { $_.Name }
            $InstalledApps = Invoke-Native { scoop list 6>$Null } | ForEach-Object { $_.Name }

            $Scoop = $Profile.scoop

            $RequiredBuckets = $Scoop.buckets
            $RequiredApps = $Scoop.programs

            $RequiredBuckets | ForEach-Object {
              $BucketName = $_

              if (-not ($InstalledBuckets.Contains($BucketName))) {
                $ChildLogger.Info($(Invoke-Native { scoop bucket add $BucketName }))
              }

              $ChildLogger.Info(" $BucketName bucket installed.")
            }

            $RequiredApps | ForEach-Object {
              $PackageName = $_

              if (-not ($InstalledApps.Contains($PackageName))) {
                $ChildLogger.Info($(Invoke-Native { scoop install $PackageName }))
              }

              $ChildLogger.Info(" $PackageName package installed.")
            }

            $this.Logger.Info(" Scoop programs installed.")
          }
        }
        $Scoop = [Scoop]::new($Logger)
        $Scoop.InstallApps()
      '';
}
