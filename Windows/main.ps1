[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$Dirname = $($MyInvocation.MyCommand.Path | Split-Path -Parent)
. "$Dirname\utils.ps1"
. "$Dirname\stamp.ps1"
. "$Dirname\config\main.ps1"
. "$Dirname\games\main.ps1"
. "$Dirname\programs\main.ps1"
. "$Dirname\registry\main.ps1"
. "$Dirname\sd\main.ps1"
. "$Dirname\wsl\main.ps1"

Initialize-Stamp

Install-Programs
Install-Config

Set-RegistryEntries
Install-FS22Mods

Install-SD
Install-Wsl
