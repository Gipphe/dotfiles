#Requires -Version 5.1

Import-Module -Force $PSScriptRoot/Utils.psm1

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

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
      Push-Location $SDDir
      $ChildLogger.Info($(pwsh .\sd.ps1))
      Pop-Location
      $ChildLogger.Info(" SD repo downloaded and initialized.")
    } catch {
      $this.Logger.ChildLogger().Info("Failed to setup SD")
    } finally {
      Remove-Item -Force -Recurse -ErrorAction 'SilentlyContinue' -Path $SDDir
    }
    $this.Logger.Info(" SD set up.")
  }
}

Function New-SD {
  param (
    [Parameter(Mandatory)]
    [PSCustomObject]$Logger
  )
  [SD]::new($Logger, $PSScriptRoot)
}

Export-ModuleMember -Function New-SD
