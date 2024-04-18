[CmdletBinding()]
Param()

$ErrorActionPreference = "Stop"

Function Install-Config
{
  [CmdletBinding()]
  Param ()

  $D = "$Dirname\config"
  $Items = @(
    @("$D\.vimrc", "$HOME\.vimrc"),
    @("$D\.wezterm.lua", "$HOME\.wezterm.lua"),
    @("$D\wsl.conf", "$HOME\wsl.conf")
  )

  $Items | ForEach-Object { Copy-Item -Path $_[0] -Destination $_[1] }
}
