[CmdletBinding()]
Param()

$ErrorActionPreference = "Stop"

. "$Dirname\utils.ps1"
. "$Dirname\games\fs22.ps1"

Function Install-Games
{
  [CmdletBinding()]
  Param ()

  Install-Fs22Mods
}
