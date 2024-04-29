#Requires -Version 7.3

Import-Module $PSScriptRoot/Utils.psm1

$ErrorActionPreference = "Stop"

class Scoop {
  Scoop() {
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
    $ScoopArgs = @('-y')
    $InstalledBuckets = Invoke-Native { scoop bucket list } | ForEach-Object { $_.Name }
    $InstalledApps = Invoke-Native { scoop list } | ForEach-Object { $_.Name }

    $RequiredBuckets = @(
      @('extras')
    )
    $RequiredApps = @(
      @('stash'),
      @('ffmpeg')
    )

    $RequiredBuckets | Where-Object { -not ($InstalledBuckets.Contains($_)) } | ForEach-Object {
      $BucketName = $_[0]
      $BucketRepo = $_[1]
      $Repo = ""
      if ($null -ne $BucketRepo)
      {
        $Repo = $BucketRepo
      }

      $this.Utils.InvokeNative({ scoop bucket add $BucketName $Repo })
    }

    $RequiredApps | Where-Object { -not ($InstalledApps.Contains($_)) } | ForEach-Object {
      $PackageName = $_[0]
      $PackageArgs = $_[1]

      $Params = ""
      if ($null -ne $PackageArgs)
      {
        $Params = @("--params", $PackageArgs)
      }

      $this.Utils.InvokeNative({ scoop install @ScoopArgs $PackageName @Params })
    }
  }
}

function New-Scoop {
  [Scoop]::new()
}

Export-ModuleMember -Function New-Scoop
