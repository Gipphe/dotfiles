#Requires -Version 5.1

param ()

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

$Mod = "$PSScriptRoot/Modules"
Import-Module $Mod/Config.psm1
Import-Module $Mod/Env.psm1
Import-Module $Mod/Games.psm1
Import-Module $Mod/Programs.psm1
Import-Module $Mod/Registry.psm1
Import-Module $Mod/SD.psm1
Import-Module $Mod/WSL.psm1

function Initialize-Main {
  $Config = New-Config
  $Env = New-Env
  $Games = New-Games
  $Programs = New-Programs
  $Registry = New-Registry
  $SD = New-SD
  $WSL = New-WSL

  $Config.Install()
  $Env.Install()
  $Games.InstallFS22Mods()
  $Programs.Install()
  $Registry.SetEntries()
  $SD.Install()
  $WSL.Install()
}

Initialize-Main
