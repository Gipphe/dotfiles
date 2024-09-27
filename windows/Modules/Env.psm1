#Requires -Version 5.1

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

class Env {
  [PSCustomObject]$Logger
  
  Env([PSCustomObject]$Logger) {
    $this.Logger = $Logger
  }
  [Void] Install() {
    $this.Logger.Info(" Setting env vars...")
    $EnvVars = @{
      'HOME' = $Env:USERPROFILE
      'XDG_CONFIG_HOME' = "$Env:USERPROFILE/.config"
    }
    $EnvVars | ForEach-Object {
      $key = $_
      $val = $EnvVars[$_]
      [Environment]::SetEnvironmentVariable($key, $val, 'User')
    }
    $this.Logger.Info(" Env vars set.")
  }
}

function New-Env {
  param (
    [Parameter(Mandatory)]
    [PSCustomObject]$Logger
  )
  [Env]::new($Logger)
}

Export-ModuleMember -Function New-Env
