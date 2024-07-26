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
      @("$($this.cfgDir)/git/ignore", "$HOME/.gitignore"),
      @("$($this.cfgDir)/git/config", "$HOME/.gitconfig"),
      @("$($this.cfgDir)/git/strise", "$HOME/.gitconfig_strise"),
      @("$($this.cfgDir)/wezterm", "$HOME/.config/wezterm")
    )

    $Items | ForEach-Object {
      if ($_.GetType().Name -eq "String") {
        Copy-Item -Recurse -Path "$($this.cfgDir)\$_" -Destination "$HOME\$_"
      } else {
        Copy-Item -Recurse -Path $_[0] -Destination $_[1]
      }
    }
  }
}

function New-Config {
  [Config]::new($PSScriptRoot)
}

Export-ModuleMember -Function New-Config
