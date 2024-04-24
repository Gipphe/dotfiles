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
    Using module "$Dirname\Config\Main.psm1"
    Using module "$Dirname\Games\Main.psm1"
    Using module "$Dirname\Programs\Main.psm1"
    Using module "$Dirname\Registry\Main.psm1"
    Using module "$Dirname\SD\Main.psm1"
    Using module "$Dirname\WSL\Main.psm1"

    $this.Config = [Config]::new()
    $this.Games = [Games]::new()
    $this.Programs = [Programs]::new()
    $this.Registry = [Registry]::new()
    $this.SD = [SD]::new()
    $this.WSL = [WSL]::new()
  }

  [void] Setup() {
    $this.Programs.Install()
    $this.Config.Install()
    $this.Registry.SetEntries()
    $this.Games.Install()
    $this.SD.Install()
    $this.WSL.Install()
  }
}

$Main = [Main]::new()
$Main.Setup()
