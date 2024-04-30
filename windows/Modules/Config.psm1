#Requires -Version 7.3

$ErrorActionPreference = "Stop"

class Config {
  [String]$CfgDir

  Config([String]$Dirname) {
    $this.CfgDir = "$Dirname/../Config"
  }

  # [Void] Install() {
  #   $Items = @(
  #     @("$($this.cfgDir)\.vimrc", "$HOME\.vimrc"),
  #     @("$($this.cfgDir)\.wezterm.lua", "$HOME\.wezterm.lua"),
  #     @("$($this.cfgDir)\wsl.conf", "$HOME\wsl.conf")
  #   )
  #
  #   $Items | ForEach-Object { Copy-Item -Path $_[0] -Destination $_[1] }
  # }
}

function New-Config {
  [Config]::new($PSScriptRoot)
}

Export-ModuleMember -Function New-Config
