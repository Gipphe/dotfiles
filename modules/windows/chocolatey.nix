{
  config,
  lib,
  util,
  ...
}:
let
  cfg = config.gipphe.windows.chocolatey;
  order = import ./order.nix;
in
util.mkToggledModule [ "windows" ] {
  name = "chocolatey";
  options.gipphe.windows.chocolatey = {
    programs = lib.mkOption {
      description = ''
        Programs to add from Chocolatey.
      '';
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
  hm = lib.mkIf (builtins.length cfg.programs > 0) {
    gipphe.windows.powershell-script =
      lib.mkOrder order.chocolatey # powershell
        ''
          class Choco {
            [PSCustomObject]$Logger

            Choco([PSCustomObject]$Logger) {
              $this.Logger = $Logger
              $this.EnsureInstalled()
            }

            [Void] EnsureInstalled() {
              try {
                Get-Command "choco" -ErrorAction Stop | Out-Null
              } catch {
                Set-ExecutionPolicy Bypass -Scope Process -Force
                [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
                Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
              }
            }

            [Void] InstallApps() {
              $this.Logger.Info(" Installing Chocolatey programs...")
              $ChocoArgs = @('-y')
              $Installed = Invoke-Native { choco list --id-only }

              $ChocoApps = @(
                ${
                  lib.pipe cfg.programs [
                    (builtins.map (p: if builtins.isString p then "\"${p}\"" else "@(\"${p.name}\", \"${p.args}\")"))
                    (lib.concatStringsSep ", ")
                  ]
                }
              )

              $ChildLogger = $this.Logger.ChildLogger()

              $ChocoApps | ForEach-Object {
                $PackageName = $_
                $PackageArgs = $null
                if ($PackageName -isnot [String]) {
                  $PackageName = $_[0]
                  $PackageArgs = $_[1]
                }
                if ($Installed.Contains($PackageName)) {
                  $ChildLogger.Info(" $PackageName is already installed")
                  return
                }

                $params = ""
                if ($null -ne $PackageArgs) {
                  $params = $PackageArgs
                }

                $ChildLogger.Info($(Invoke-Native { choco install @ChocoArgs $PackageName $params }))
                $ChildLogger.Info(" $PackageName installed.")
              }

              $this.Logger.Info(" Chocolatey programs installed.")
            }
          }

          $Choco = [Choco]::new($Logger)
          $Choco.InstallApps()
        '';
  };
}
