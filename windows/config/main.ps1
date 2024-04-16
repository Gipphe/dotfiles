[CmdletBinding()]
Param()

$ErrorActionPreference = "Stop"

Function Install-Config
{
  [CmdletBinding()]
  Param ()

  # Copy-Item -Path "$Dirname\config\.vimrc" -Destination "$HOME\.vimrc"
  Copy-Item -Path "$Dirname\config\.wezterm.lua" -Destination "$Env:HOME\.wezterm.lua" -Force
}
