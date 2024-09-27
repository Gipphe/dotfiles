#Requires -Version 5.1

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

class Config {
  [PSCustomObject]$Logger
  [String]$CfgDir

  Config([PSCustomObject]$Logger, [String]$Dirname) {
    $this.Logger = $Logger
    $this.CfgDir = "$Dirname/../Config"
  }

  [Void] Install() {
    $this.Logger.Info(" Copying config files...")
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
      @("$($this.CfgDir)/wezterm", "$HOME/.config/wezterm"),
      @("$($this.CfgDir)/PSProfile.ps1", "$HOME/Documents/PowerShell/Microsoft.PowerShell_profile.ps1"),
      @("$($this.CfgDir)/starship.toml", "$HOME/.config/starship.toml"),
      @("$($this.CfgDir)/zoxide.ps1", "$HOME/.config/zoxide.ps1"),
      @("$($this.CfgDir)/nvim/init.vim", "$HOME/AppData/Local/nvim/init.vim")
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

      # Ensure parent dir exists
      $ToDir = Split-Path -Parent $To
      if (-not (Test-Path -PathType Container $ToDir)) {
        New-Item -Force -ItemType Directory $ToDir
      }

      # Clean out existing destination if it is a directory. Otherwise, we'll
      # end up copying _into_ the existing directory.
      if (Test-Path -PathType Container $To) {
        Remove-Item -Recurse -Force $To
      }

      Copy-Item -Force -Recurse -Path $From -Destination $To
    }

    $this.Logger.Info(" Config files copied.")
  }
}

function New-Config {
  param (
    [Parameter(Mandatory)]
    [PSCustomObject]$Logger
  )
  [Config]::new($PSScriptRoot)
}

Export-ModuleMember -Function New-Config
