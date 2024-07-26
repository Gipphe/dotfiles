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
      ".wslconfig",
      @("$($this.CfgDir)/git/ignore", "$HOME/.gitignore"),
      @("$($this.CfgDir)/git/config", "$HOME/.gitconfig"),
      @("$($this.CfgDir)/git/strise", "$HOME/.gitconfig_strise"),
      @("$($this.CfgDir)/wezterm", "$HOME/.config/wezterm")
    )

    $Items | ForEach-Object {
      if ($_.GetType().Name -eq "String") {
        Copy-Item -Force -Recurse -Path "$($this.cfgDir)\$_" -Destination "$HOME\$_"
      } else {
        Copy-Item -Force -Recurse -Path $_[0] -Destination $_[1]
      }
    }
  }
}

function New-Config {
  [Config]::new($PSScriptRoot)
}

Export-ModuleMember -Function New-Config
