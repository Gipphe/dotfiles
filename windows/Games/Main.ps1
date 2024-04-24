class Games {
  [PSCustomObject]$Utils
  [PSCustomObject]$FS22

  Games() {
    $Dirname = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
    . "$Dirname\FS22.ps1"

    $this.FS22 = [FS22]::new()
  }

  [void] Install() {
    $this.FS22.InstallMods()
  }
}
