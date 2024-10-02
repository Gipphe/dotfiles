#Requires -Version 5.1

Import-Module -Force $PSScriptRoot/Utils.psm1

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

class Scoop {
  [PSCustomObject]$Logger
  
  Scoop([PSCustomObject]$Logger) {
    $this.Logger = $Logger
    $this.EnsureInstalled()
  }

  [Void] EnsureInstalled() {
    try {
      Get-Command "scoop" -ErrorAction Stop
    } catch {
      Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
      Invoke-RestMethod -Uri "https://get.scoop.sh" | Invoke-Expression
    }
  }

  [Void] InstallApps() {
    $this.Logger.Info(" Installing scoop programs...")
    $ChildLogger = $this.Logger.ChildLogger()
    $ScoopArgs = @('-y')
    $InstalledBuckets = Invoke-Native { scoop bucket list 6>$Null } | ForEach-Object { $_.Name }
    $InstalledApps = Invoke-Native { scoop list 6>$Null } | ForEach-Object { $_.Name }

    $RequiredBuckets = @(
      'extras'
    )
    $RequiredApps = @(
      'direnv',
      'ffmpeg',
      'neovide',
      'neovim',
      'stash'
    )

    $RequiredBuckets | ForEach-Object {
      $BucketName = $_

      if (-not ($InstalledBuckets.Contains($BucketName))) {
        $ChildLogger.Info($(Invoke-Native { scoop bucket add $BucketName }))
      }

      $ChildLogger.Info(" $BucketName bucket installed.")
    }

    $RequiredApps | ForEach-Object {
      $PackageName = $_

      if (-not ($InstalledApps.Contains($PackageName))) {
        $ChildLogger.Info($(Invoke-Native { scoop install @ScoopArgs $PackageName }))
      }

      $ChildLogger.Info(" $PackageName package installed.")
    }

    $this.Logger.Info(" Scoop programs installed.")
  }
}

function New-Scoop {
  param (
    [Parameter(Mandatory)]
    [PSCustomObject]$Logger
  )
  [Scoop]::new($Logger)
}

Export-ModuleMember -Function New-Scoop
