class Utils {
  [void] InstallFromWeb([String]$Name, [String]$URI) {
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

  [void] TestIsInstalledInWinget([String]$Name) {
    winget list --name $Name > $Null
    return $LASTEXITCODE -eq 0
  }

  [void] NewShortcut([String]$Source, [String]$Destination, [String]$Arguments) {
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($Destination)
    $Shortcut.TargetPath = $Source
    $Shortcut.Arguments = $Arguments
    $Shortcut.Save()
    Write-Output "Created shortcut"
  }

  [void] InstallWithWinget([String]$Name) {
    If (-Not (Test-IsInstalledInWinget $Name))
    {
      Invoke-Native { winget install --name $Name }
    }
  }

  [void] InvokeNative([ScriptBlock]$ScriptBlock) {
    & @ScriptBlock
    If ($LASTEXITCODE -Ne 0)
    {
      Write-Error "Non-zero exit code $LASTEXITCODE"
      Exit $LASTEXITCODE 
    }
  }
}
