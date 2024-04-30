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
      @("$($this.cfgDir)\.vimrc", "$HOME\.vimrc"),
      @("$($this.cfgDir)\.wezterm.lua", "$HOME\.wezterm.lua"),
      @("$($this.cfgDir)\wsl.conf", "$HOME\wsl.conf")
    )

    $Items | ForEach-Object { Copy-Item -Path $_[0] -Destination $_[1] }
  }
}

function New-Config {
  [Config]::new($PSScriptRoot)
}

Export-ModuleMember -Function New-Config
