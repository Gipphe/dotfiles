{
  lib,
  config,
  util,
  ...
}:
let
  cfg = config.gipphe.windows.games.fs22;
  inherit (import ../helpers.nix { inherit lib; }) concatStringsList;
in
util.mkToggledModule
  [
    "windows"
    "games"
  ]
  {
    name = "fs22";
    options.gipphe.windows.games.fs22 = {
      modUrls = lib.mkOption {
        description = "URLs to mods to add.";
        type = with lib.types; listOf str;
      };
    };
    hm = lib.mkIf (builtins.length cfg.modUrls > 0) {
      gipphe.windows.powershell-script = # powershell
        ''
          class FS22 {
            [PSCustomObject]$Logger
            [String]$FS22ModDir
            [String[]]$FS22Mods

            FS22([PSCustomObject]$Logger) {
              $this.Logger = $Logger
              $baseUrl = $Env:USERPROFILE
              $this.FS22ModDir = "$baseUrl/Documents/My Games/FarmingSimulator2022/mods"

              $this.FS22Mods = @(
                ${concatStringsList cfg.modUrls}
              )
            }

            [Void] InstallFS22Mod([PSCustomObject]$ChildLogger, [String]$URI) {
              $FileName = $URI.Substring($URI.LastIndexOf("/") + 1)
              $DestPath = "$($this.FS22ModDir)/$FileName"

              if (Test-Path -Path $DestPath) {
                return
              }

              $ChildLogger.Info($(Invoke-WebRequest -Uri -OutFile $DestPath))
            }

            [Void] InstallFS22Mods() {
              $this.Logger.Info(" Downloading FS22 mods...")
              if (-not (Test-Path -Path $this.FS22ModDir)) {
                $this.Logger.Info(" FS22 mods folder is missing. Skipping mod installation.")
                return
              }

              $ChildLogger = $this.Logger.ChildLogger()
              foreach ($Mod in $this.FS22Mods) {
                $this.InstallFS22Mod($ChildLogger, $Mod)
                $ModName = Split-Path -Leaf $Mod
                $ChildLogger.Info(" $ModName FS22 mod installed")
              }
              $this.Logger.Info(" FS22 mods downloaded.")
            }
          }

          [FS22]::new($Logger).InstallFS22Mods()
        '';
    };
  }
