#Requires -Version 5.1

param ()

$ErrorActionPreference = "Stop"

$Mod = "$PSScriptRoot/Modules"
Import-Module $Mod/Config.psm1
Import-Module $Mod/Games.psm1
# Import-Module $Mod/Programs.psm1
# Import-Module $Mod/Registry.psm1
# Import-Module $Mod/SD.psm1
# Import-Module $Mod/WSL.psm1

function Initialize-Main {
  $Config = New-Config
  $Games = New-Games
  # $Programs = New-Programs
  # $Registry = New-Registry
  # $SD = New-SD
  # $WSL = New-WSL

  $Config.Install()
  $Games.InstallFS22Mods()
  # $Programs.Install()
  # $Registry.SetEntries()
  # $SD.Install()
  # $WSL.Install()
}

Initialize-Main
