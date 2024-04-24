class Programs {
  [PSCustomObject]$Stamp
  [PSCustomObject]$Utils
  [PSCustomObject]$Choco
  [PSCustomObject]$Scoop

  Programs() {
    $Dirname = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
    . "$Dirname\..\Utils.ps1"
    . "$Dirname\..\Stamp.ps1"
    . "$Dirname\Choco.ps1"
    . "$Dirname\Scoop.ps1"

    $this.Stamp = [Stamp]::new()
    $this.Utils = [Utils]::new()
    $this.Choco = [Choco]::new()
    $this.Scoop = [Scoop]::new()
  }

  [void] Install() {
    $this.Choco.InstallApps
    $this.Scoop.InstallApps

    $this.Stamp.Register("install-1password", {
      $this.Utils.InstallFromWeb("1password", "https://downloads.1password.com/win/1PasswordSetup-latest.exe")
    })
    $this.Stamp.Register("install-firefox-developer-edition", {
      $this.Utils.InstallFromWeb("Firefox Developer Edition", "https://download-installer.cdn.mozilla.net/pub/devedition/releases/120.0b4/win32/en-US/Firefox%20Installer.exe")
    })
    $this.Stamp.Register("install-ldplayer", {
      $this.Utils.InstallFromWeb("LDPlayer", "https://ldcdn.ldmnq.com/download/ldad/LDPlayer9.exe?n=LDPlayer9_ens_1001_ld.exe")
    })
    $this.Stamp.Register("install-visipics", {
      $this.Utils.InstallFromWeb("VisiPics", "https://altushost-swe.dl.sourceforge.net/project/visipics/VisiPics-1-31.exe")
    })
  }
}
