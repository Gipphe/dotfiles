#Requires -Version 5.1

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

class Env {
  [Void] Install() {
    Write-Information " Setting env vars..."
    $EnvVars = @{
      'HOME' = $Env:USERPROFILE
      'XDG_CONFIG_HOME' = "$Env:USERPROFILE/.config"
    }
    $EnvVars | ForEach-Object {
      $key = $_
      $val = $EnvVars[$_]
      [Environment]::SetEnvironmentVariable($key, $val, 'User')
    }
    Write-Information " Env vars set."
  }
}

function New-Env {
  [Env]::new()
}

Export-ModuleMember -Function New-Env
