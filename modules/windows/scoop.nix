{
  lib,
  config,
  util,
  ...
}:
let
  cfg = config.gipphe.windows.scoop;
  inherit (import ./helpers.nix { inherit lib; }) concatStringsList;
in
util.mkToggledModule [ "windows" ] {
  name = "scoop";
  options.gipphe.windows.scoop = {
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

  hm = lib.mkIf (builtins.length cfg.programs > 0) {
    gipphe.windows.powershell-script = ''
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

          $RequiredBuckets = @(
            ${concatStringsList cfg.buckets}
          )
          $RequiredApps = @(
            ${concatStringsList cfg.programs}
          )

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
  };
}
