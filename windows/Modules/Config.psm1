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
      $From = ''
      $To = ''
      if ($_.GetType().Name -eq "String") {
        $From = "$($this.cfgDir)\$_"
        $To = "$HOME\$_"
      } else {
        $From = $_[0]
        $To = $_[1]
      }
      if (Test-Path -PathType Container $To) {
        Remove-Item -Recurse -Force $To
      }
      Copy-Item -Force -Recurse -Path $From -Destination $To
    }
  }
}

function New-Config {
  [Config]::new($PSScriptRoot)
}

Export-ModuleMember -Function New-Config
