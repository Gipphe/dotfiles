class Scoop {
  [PSCustomObject]$Utils

  Scoop() {
    $Dirname = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
    . "$Dirname\..\Utils.ps1"

    $this.Utils = New-Utils

    $this.EnsureInstalled()
  }

  [void] EnsureInstalled() {
    try
    {
      Get-Command "scoop" -ErrorAction Stop
    } catch
    {
      Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
      Invoke-RestMethod -Uri "https://get.scoop.sh" | Invoke-Expression
    }
  }

  [void] InstallApps() {
    $ScoopArgs = @('-y')
    $InstalledBuckets = $this.Utils.InvokeNative({ scoop bucket list } | ForEach-Object { $_.Name })
    $InstalledApps = $this.Utils.InvokeNative({ scoop list } | ForEach-Object { $_.Name })

    $RequiredBuckets = @(
      @('extras')
    )
    $RequiredApps = @(
      @('stash'),
      @('ffmpeg')
    )

    $RequiredBuckets | Where-Object { -Not ($InstalledBuckets.Contains($_)) } | ForEach-Object {
      $BucketName = $_[0]
      $BucketRepo = $_[1]
      $Repo = ""
      if ($Null -Ne $BucketRepo)
      {
        $Repo = $BucketRepo
      }

      $this.Utils.InvokeNative({ scoop bucket add $BucketName $Repo })
    }

    $RequiredApps | Where-Object { -Not ($InstalledApps.Contains($_)) } | ForEach-Object {
      $PackageName = $_[0]
      $PackageArgs = $_[1]

      $Params = ""
      if ($Null -ne $PackageArgs)
      {
        $Params = @("--params", $PackageArgs)
      }

      $this.Utils.InvokeNative({ scoop install @ScoopArgs $PackageName @Params })
    }
  }
}

Function New-Scoop {
  [Scoop]::new()
}
