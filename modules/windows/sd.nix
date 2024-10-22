{ util, lib, ... }:
util.mkToggledModule [ "windows" ] {
  name = "sd";
  hm.gipphe.windows.powershell-script =
    lib.mkOrder (import ./order.nix).sd # powershell
      ''
        class SD {
          [PSCustomObject]$Logger
          [String]$Dirname

          SD([PSCustomObject]$Logger, [String]$Dirname) {
            $this.Logger = $Logger
            $this.Dirname = $Dirname
          }

          [Void] Install() {
            $this.Logger.Info(" Setting up SD...")
            $ChildLogger = $this.Logger.ChildLogger()
            $SDDir = "$($this.Dirname)\_temp"
            Remove-Item -Force -Recurse -ErrorAction 'SilentlyContinue' -Path $SDDir
            try {
              Invoke-Native { git clone "https://codeberg.org/Gipphe/sd.git" "$SDDir" }
              if (-not (Test-Path -PathType Container "$SDDir")) {
                $ChildLogger.Info("✗ $SDDir does not exist, even though we _just_ cloned into it.")
                return
              }
              try {
                Push-Location $SDDir
                Invoke-Native { pwsh .\sd.ps1 }
                Pop-Location
              } catch {
                Pop-Location
                throw $error
              }
              $ChildLogger.Info(" SD repo downloaded and initialized.")
            } catch {
              $ChildLogger.Info("✗ Failed to setup SD")
              $ChildLogger.Info($error[0])
            } finally {
              Remove-Item -Force -Recurse -ErrorAction 'SilentlyContinue' -Path $SDDir
            }
            $this.Logger.Info(" SD set up.")
          }
        }
        $SD = [SD]::new($Logger, $PSScriptRoot)
        $SD.Install()
      '';
}
