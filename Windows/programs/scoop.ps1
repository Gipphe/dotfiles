[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

. "$Dirname\utils.ps1"

function Initialize-Scoop
{
  try
  {
    Get-Command "scoop" -ErrorAction Stop
  } catch
  {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
  }
}

function Install-ScoopApps
{
  $ScoopArgs = @('-y')
  $InstalledBuckets = Invoke-Native { scoop bucket list } | ForEach-Object { $_.Name }
  $InstalledApps = Invoke-Native { scoop list } | ForEach-Object { $_.Name }

  Initialize-Scoop
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

    Invoke-Native { scoop bucket add $BucketName $Repo }
  }

  $RequiredApps | Where-Object { -Not ($InstalledApps.Contains($_)) } | ForEach-Object {
    $PackageName = $_[0]
    $PackageArgs = $_[1]

    $Params = ""
    if ($Null -ne $PackageArgs)
    {
      $Params = @("--params", $PackageArgs)
    }

    Invoke-Native { scoop install @ScoopArgs $PackageName @Params }
  }
}
