$Dirname = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
. "$Dirname\FS22.ps1"

class Games {
  [PSCustomObject]$FS22

  Games() {
    $this.FS22 = New-FS22
  }

  [void] Install() {
    $this.FS22.InstallMods()
  }
}

Function New-Games {
  [Games]::new()
}
