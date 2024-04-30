#Requires -Version 5.1

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

function Install-FromWeb {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [String]$Name,

    [Parameter(Mandatory)]
    [String]$URI
  )

  if (Test-IsInstalledInWinget $Name)
  {
    Write-Information "$Name is already installed"
    return
  }

  Invoke-WebRequest -URI $URI -OutFile "$HOME/Downloads/temp.exe"

  Start-Process "$HOME/Downloads/temp.exe" -Wait
  Remove-Item "$HOME/Downloads/temp.exe"
  Write-Information "Installed $Name"
}

$Programs = $null

function Test-IsInstalledInWinget {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [String]$Name
  )

  Write-Information "$Programs"
  if ($null -eq $Programs) {
    $Programs = $($(winget list).ToLower() -split "`n")
  }

  $Name = $Name.ToLower()

  foreach ($line in $Programs) {
    if ($line.StartsWith($Name)) {
      return $true
    }
  }
  return $false
}

function New-Shortcut {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [ValidateScript({ Test-Path $_ })]
    [String]$Source,

    [Parameter(Mandatory)]
    [String]$Destination,

    [Parameter(Mandatory)]
    [String]$Arguments
  )

  $WshShell = New-Object -comObject WScript.Shell
  $Shortcut = $WshShell.CreateShortcut($Destination)
  $Shortcut.TargetPath = $Source
  $Shortcut.Arguments = $Arguments
  $Shortcut.Save()
  Write-Information "Created shortcut"
}

function Install-WithWinget {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [String]$Name
  )

  If (-Not (Test-IsInstalledInWinget $Name))
  {
    Invoke-Native { winget install --name $Name }
  }
}

function Invoke-Native {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [ScriptBlock]$ScriptBlock
  )

  & @ScriptBlock
  If ($LASTEXITCODE -Ne 0)
  {
    Write-Error "Non-zero exit code $LASTEXITCODE"
    Exit $LASTEXITCODE 
  }
}

Export-ModuleMember -Function `
  Install-FromWeb, `
  Test-IsInstalledInWinget, `
  New-Shortcut, `
  Install-WithWinget, `
  Invoke-Native
