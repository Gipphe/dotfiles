[CmdletBinding()]
Param()

$ErrorActionPreference = "Stop"

class Main {
  [PSCustomObject]$Config
  [PSCustomObject]$Games
  [PSCustomObject]$Programs
  [PSCustomObject]$Registry
  [PSCustomObject]$SD
  [PSCustomObject]$WSL

  Main() {
    $Dirname = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
    . "$Dirname\Config\Main.ps1"
    . "$Dirname\Games\Main.ps1"
    . "$Dirname\Programs\Main.ps1"
    . "$Dirname\Registry\Main.ps1"
    . "$Dirname\SD\Main.ps1"
    . "$Dirname\WSL\Main.ps1"

    $this.Config = New-Config
    $this.Games = New-Games
    $this.Programs = New-Programs
    $this.Registry = New-Registry
    $this.SD = New-SD
    $this.WSL = New-WSL
  }

  [void] Setup() {
    $this.Programs.Install()
    # $this.Config.Install()
    # $this.Registry.SetEntries()
    # $this.Games.Install()
    # $this.SD.Install()
    # $this.WSL.Install()
  }
}

$Main = [Main]::new()
$Main.Setup()
