#Requires -Version 5.1

Import-Module -Force $PSScriptRoot/Utils.psm1

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

class Choco {
  [PSCustomObject]$Logger

  Choco([PSCustomObject]$Logger) {
    $this.Logger = $Logger
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
    $this.Logger.Info(" Installing Chocolatey programs...")
    $ChocoArgs = @('-y')
    $Installed = Invoke-Native { choco list --id-only }

    $ChocoApps = @(
      '7zip',
      'XnViewMP',
      'barrier',
      'cyberduck',
      'discord',
      'docker-desktop',
      'dust',
      'epicgameslauncher',
      'everything',
      'everythingpowertoys',
      'filen',
      'firacodenf',
      'fzf',
      'gdlauncher',
      'geforce-experience',
      'git',
      'greenshot',
      'humble-app',
      'irfanview',
      'irfanview-languages',
      'irfanviewplugins',
      'k-litecodecpack-standard',
      'lghub',
      'logseq',
      'microsoft-windows-terminal',
      'msiafterburner',
      'notion',
      'nvidia-broadcast',
      'openssh',
      'paint.net',
      'powershell-core',
      'powertoys',
      'qbittorrent',
      'restic',
      'rsync',
      'slack',
      'spotify',
      'starship',
      'steam',
      'sumatrapdf',
      'sunshine',
      'teamviewer',
      'vcredist-all',
      'vivaldi',
      'voicemeeter',
      'wezterm',
      'windhawk',
      'windirstat',
      'zoxide'
    )

    $ChildLogger = $this.Logger.ChildLogger()

    $ChocoApps | ForEach-Object {
      $PackageName = $_
      $PackageArgs = $null
      if ($PackageName -isnot [String]) {
        $PackageName = $_[0]
        $PackageArgs = $_[1]
      }
      if ($Installed.Contains($PackageName)) {
        $ChildLogger.Info(" $PackageName is already installed")
        return
      }

      $params = ""
      if ($null -ne $PackageArgs) {
        $params = @("--params", $PackageArgs)
      }

      $ChildLogger.Info($(Invoke-Native { choco install @ChocoArgs $PackageName @params }))
      $ChildLogger.Info(" $PackageName installed.")
    }

    $this.Logger.Info(" Chocolatey programs installed.")
  }
}

function New-Choco {
  param (
    [Parameter(Mandatory)]
    [PSCustomObject]$Logger
  )
  [Choco]::new($Logger)
}

Export-ModuleMember -Function New-Choco
