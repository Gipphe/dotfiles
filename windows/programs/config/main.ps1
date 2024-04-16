[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

. "$Dirname\utils.ps1"

Function Set-ProgramConfigurations {
  [CmdletBinding()]
  Param ()

  Copy-Item -Path "$Dirname\programs\config\.wezterm.lua" -Destination "$Env:HOME\.wezterm.lua" -Force
}
