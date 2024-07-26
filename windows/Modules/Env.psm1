#Requires -Version 5.1

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

class Env {
  [Void] Install() {
    $EnvVars = @{
      'HOME' = $Env:USERPROFILE
      'XDG_CONFIG_HOME' = "$Env:USERPROFILE/.config"
    }
    $EnvVars | ForEach-Object {
      $key = $_
      $val = $EnvVars[$_]
      [Environment]::SetEnvironmentVariable($key, $val, 'User')
    }
  }
}

function New-Env {
  [Env]::new()
}

Export-ModuleMember -Function New-Env
