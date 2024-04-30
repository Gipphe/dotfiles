#Requires -Version 5.1

Import-Module $PSScriptRoot/Utils.psm1
Import-Module $PSScriptRoot/Choco.psm1
Import-Module $PSScriptRoot/Scoop.psm1
Import-Module $PSScriptRoot/Stamp.psm1

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

class Programs {
  [PSCustomObject]$Stamp
  [PSCustomObject]$Choco
  [PSCustomObject]$Scoop

  Programs() {
    $this.Stamp = New-Stamp
    $this.Choco = New-Choco
    $this.Scoop = New-Scoop
  }

  [void] Install() {
    $this.Choco.InstallApps
    $this.Scoop.InstallApps

    $this.Stamp.Register("install-1password", {
      Install-FromWeb "1password", "https://downloads.1password.com/win/1PasswordSetup-latest.exe" 
    })
    $this.Stamp.Register("install-firefox-developer-edition", {
      Install-FromWeb "Firefox Developer Edition", "https://download-installer.cdn.mozilla.net/pub/devedition/releases/120.0b4/win32/en-US/Firefox%20Installer.exe" 
    })
    $this.Stamp.Register("install-ldplayer", {
      Install-FromWeb "LDPlayer", "https://ldcdn.ldmnq.com/download/ldad/LDPlayer9.exe?n=LDPlayer9_ens_1001_ld.exe" 
    })
    $this.Stamp.Register("install-visipics", {
      Install-FromWeb "VisiPics", "https://altushost-swe.dl.sourceforge.net/project/visipics/VisiPics-1-31.exe" 
    })
  }
}

Function New-Programs {
  [Programs]::new()
}

Export-ModuleMember -Function New-Programs
