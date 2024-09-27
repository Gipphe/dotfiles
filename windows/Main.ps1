#Requires -Version 5.1

param ()

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

$Mod = "$PSScriptRoot/Modules"
Import-Module -Force $Mod/Config.psm1
Import-Module -Force $Mod/Env.psm1
Import-Module -Force $Mod/Games.psm1
Import-Module -Force $Mod/Logger.psm1
Import-Module -Force $Mod/Programs.psm1
Import-Module -Force $Mod/Registry.psm1
Import-Module -Force $Mod/SD.psm1
Import-Module -Force $Mod/WSL.psm1

function Initialize-Main {
  $Logger = New-Logger
  $Config = New-Config $Logger
  $Env = New-Env $Logger
  $Games = New-Games $Logger
  $Programs = New-Programs $Logger
  $Registry = New-Registry $Logger
  $SD = New-SD $Logger
  $WSL = New-WSL $Logger

  $Config.Install()
  $Env.Install()
  $Games.InstallFS22Mods()
  $Programs.Install()
  $Registry.SetEntries()
  $SD.Install()
  $WSL.Install()
}

Initialize-Main
