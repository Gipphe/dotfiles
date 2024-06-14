#Requires -Version 5.1

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

class Config {
  [String]$CfgDir

  Config([String]$Dirname) {
    $this.CfgDir = "$Dirname/../Config"
  }

  [Void] Install() {
    if ($null -eq $Env:HOME) {
      $Env:HOME = $Env:USERPROFILE
    }
    $HOME = $Env:HOME
    $Items = @(
      ".vimrc",
      "wezterm",
      ".wslconfig"
    )

    $Items | ForEach-Object {
      if ($_.GetType().Name -eq "String") {
        Copy-Item -Path "$($this.cfgDir)\$_" -Destination "$HOME\$_"
      } else {
        Copy-Item -Path $_[0] -Destination $_[1]
      }
    }
  }
}

function New-Config {
  [Config]::new($PSScriptRoot)
}

Export-ModuleMember -Function New-Config
