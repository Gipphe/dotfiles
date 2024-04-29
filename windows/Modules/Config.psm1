#Requires -Version 7.3

$ErrorActionPreference = "Stop"

class Config {
  Config([String]$Dirname) {
    $this.Dirname = "$Dirname/../Config"
  }

  [Void] Install() {
    $D = "$($this.Dirname)\config"
    $Items = @(
      @("$D\.vimrc", "$HOME\.vimrc"),
      @("$D\.wezterm.lua", "$HOME\.wezterm.lua"),
      @("$D\wsl.conf", "$HOME\wsl.conf")
    )

    $Items | ForEach-Object { Copy-Item -Path $_[0] -Destination $_[1] }
  }
}

function New-Config {
  [Config]::new($PSScriptRoot)
}

Export-ModuleMember -Function New-Config
