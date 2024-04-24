class Config {
  Config() {
    $this.Dirname = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
  }

  [void] Install() {
    $D = "$($this.Dirname)\config"
    $Items = @(
      @("$D\.vimrc", "$HOME\.vimrc"),
      @("$D\.wezterm.lua", "$HOME\.wezterm.lua"),
      @("$D\wsl.conf", "$HOME\wsl.conf")
    )

    $Items | ForEach-Object { Copy-Item -Path $_[0] -Destination $_[1] }
  }
}
Function New-Config {
  [Config]::new()
}
