Function Install-FromWeb
{
  [CmdletBinding()]
  Param (
    [Parameter(Mandatory)]
    [String]$Name,

    [Parameter(Mandatory)]
    [String]$URI
  )

  If (Test-IsInstalledInWinget $Name)
  {
    Write-Output "$Name is already installed"
    return
  }

  Invoke-WebRequest -URI $URI -OutFile "$HOME/Downloads/temp.exe"

  Start-Process "$HOME/Downloads/temp.exe" -Wait
  Remove-Item "$HOME/Downloads/temp.exe"
  Write-Output "Installed $Name"
}

Function Test-IsInstalledInWinget
{
  Param (
    [String]$Name
  )

  winget list --name $Name > $Null
  return $LASTEXITCODE -eq 0
}

Function New-Shortcut
{
  Param (
    [Parameter(Mandatory)]
    [String]$Source,

    [Parameter(Mandatory)]
    [String]$Destination,

    [String]$Arguments
  )

  $WshShell = New-Object -comObject WScript.Shell
  $Shortcut = $WshShell.CreateShortcut($Destination)
  $Shortcut.TargetPath = $Source
  $Shortcut.Arguments = $Arguments
  $Shortcut.Save()
  Write-Output "Created shortcut"
}

Function Install-WithWinget
{
  Param (
    [String]$Name
  )

  If (-Not (Test-IsInstalledInWinget $Name))
  {
    Invoke-Native { winget install --name $Name }
  }
}

Function Invoke-Native
{
  Param (
    [ScriptBlock]$ScriptBlock,
    [String]$ErrorAction = $ErrorActionPreference
  )
  & @ScriptBlock
  If (($LASTEXITCODE -Ne 0 ) -And $ErrorAction -Eq "Stop")
  {
    Write-Error "Non-zero exit code $LASTEXITCODE"
    Exit $LASTEXITCODE 
  }
}

