#Requires -Version 7.3

$ErrorActionPreference = "Stop"

class Config {
  [String]$Dirname

  Config([String]$Dirname) {
    $this.Dirname = "$Dirname/../Config"
  }

  # [Void] Install() {
  #   $cfgdir = "$($this.Dirname)\config"
  #   $Items = @(
  #     @("$cfgDir\.vimrc", "$HOME\.vimrc"),
  #     @("$cfgDir\.wezterm.lua", "$HOME\.wezterm.lua"),
  #     @("$cfgDir\wsl.conf", "$HOME\wsl.conf")
  #   )
  #
  #   $Items | ForEach-Object { Copy-Item -Path $_[0] -Destination $_[1] }
  # }
}

function New-Config {
  Write-Host "PSScriptRoot: $PSScriptRoot"
  [Config]::new($PSScriptRoot)
}

Export-ModuleMember -Function New-Config
