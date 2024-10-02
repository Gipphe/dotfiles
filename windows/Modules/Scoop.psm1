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
      @('extras')
    )
    $RequiredApps = @(
      @('direnv'),
      @('ffmpeg'),
      @('neovide'),
      @('neovim'),
      @('stash')
    )

    $RequiredBuckets | ForEach-Object {
      $BucketName = $_[0]
      $BucketRepo = $_[1]

      if (-not ($InstalledBuckets.Contains($_))) {
        $Repo = ""
        if ($null -ne $BucketRepo)
        {
          $Repo = $BucketRepo
        }

        $ChildLogger.Info($(Invoke-Native { scoop bucket add $BucketName $Repo }))
      }

      $ChildLogger.Info(" $BucketName bucket installed.")
    }

    $RequiredApps | ForEach-Object {
      $PackageName = $_[0]
      $PackageArgs = $_[1]

      if (-not ($InstalledApps.Contains($PackageName))) {
        $Params = ""
        if ($null -ne $PackageArgs)
        {
          $Params = @("--params", $PackageArgs)
        }

        $ChildLogger.Info($(Invoke-Native { scoop install @ScoopArgs $PackageName @Params }))
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
