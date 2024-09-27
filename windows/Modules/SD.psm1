#Requires -Version 5.1

Import-Module $PSScriptRoot/Utils.psm1

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
    $SDDir = "$($this.Dirname)\_temp"
    Remove-Item -Force -Recurse -ErrorAction 'SilentlyContinue' -Path $SDDir
    try {
      Invoke-Native { git clone "https://codeberg.org/Gipphe/sd.git" "$SDDir" }
      . "$SDDir\sd.ps1"
    } catch {
      $this.Logger.Info("Failed to setup SD")
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
