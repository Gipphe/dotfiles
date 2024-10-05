{ util, ... }:
util.mkToggledModule [ "windows" ] {
  name = "sd";
  hm.gipphe.windows.powershell-script = # powershell
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
            $ChildLogger.Info($(Invoke-Native { git clone "https://codeberg.org/Gipphe/sd.git" "$SDDir" }))
            try {
              Push-Location $SDDir
              $ChildLogger.Info($(Invoke-Native { pwsh .\sd.ps1 }))
              Pop-Location
            } catch {
              Pop-Location
              throw $error
            }
            $ChildLogger.Info(" SD repo downloaded and initialized.")
          } catch {
            $this.Logger.ChildLogger().Info("Failed to setup SD")
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
