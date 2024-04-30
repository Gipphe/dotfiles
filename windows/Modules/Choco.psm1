#Requires -Version 5.1

Import-Module $PSScriptRoot/Utils.psm1

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

class Choco {
  Choco([PSCustomObject]$Utils) {
    $this.EnsureInstalled()
  }

  [Void] EnsureInstalled() {
    try {
      Get-Command "choco" -ErrorAction Stop | Out-Null
    } catch {
      Set-ExecutionPolicy Bypass -Scope Process -Force
      [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
      Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
  }

  [Void] InstallApps() {
    $ChocoArgs = @('-y')
    $Installed = $(Invoke-Native { choco list --id-only })

    $ChocoApps = @(
      @('7zip'),
      @('barrier'),
      @('cyberduck'),
      @('discord'),
      @('docker-desktop'),
      @('dropbox'),
      @('epicgameslauncher'),
      @('filen'),
      @('firacodenf'),
      @('gdlauncher'),
      @('geforce-experience'),
      @('git'),
      @('greenshot'),
      @('humble-app'),
      @('irfanview'),
      @('irfanview-languages'),
      @('irfanviewplugins'),
      @('k-litecodecpack-standard'),
      @('lghub'),
      @('microsoft-windows-terminal'),
      @('msiafterburner'),
      @('notion'),
      @('nvidia-broadcast'),
      @('obsidian'),
      @('openssh'),
      @('paint.net'),
      @('powershell-core'),
      @('powertoys'),
      @('qbittorrent'),
      @('restic'),
      @('rsync'),
      @('slack'),
      @('spotify'),
      @('start10'),
      @('steam'),
      @('sumatrapdf'),
      @('sunshine'),
      @('teamviewer'),
      @('virtualbox'),
      @('virtualbox-guest-additions-guest.install'),
      @('vivaldi'),
      @('voicemeeter'),
      @('vscode', '/NoDesktopIcon /NoQuicklaunchIcon'), # TODO replace with vscodium
      @('wezterm'),
      @('windirstat')
    )

    $ChocoApps | ForEach-Object {
      $PackageName = $_[0]
      $PackageArgs = $_[1]
      if ($Installed.Contains($PackageName)) {
        Write-Information "$PackageName is already installed"
        return
      }

      $params = ""
      if ($Null -ne $PackageArgs) {
        $params = @("--params", $PackageArgs)
      }

      Invoke-Native { choco install @ChocoArgs $PackageName @params }
    }
  }
}

function New-Choco {
  [Choco]::new()
}

Export-ModuleMember -Function New-Choco
