[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

. "$Dirname\utils.ps1"
. "$Dirname\stamp.ps1"
. "$Dirname\programs\choco.ps1"
. "$Dirname\programs\scoop.ps1"
. "$Dirname\programs\config\main.ps1"

Function Install-Programs
{
  [CmdletBinding()]
  Param ()

  Initialize-Stamp

  Install-ChocoApps
  Install-ScoopApps

  Set-ProgramConfiguration

  Register-Stamp "install-1password" {
    Install-FromWeb "1password" "https://downloads.1password.com/win/1PasswordSetup-latest.exe"
  }
  Register-Stamp "install-firefox-developer-edition" {
    Install-FromWeb "Firefox Developer Edition" "https://download-installer.cdn.mozilla.net/pub/devedition/releases/120.0b4/win32/en-US/Firefox%20Installer.exe"
  }
  Register-Stamp "install-ldplayer" {
    Install-FromWeb "LDPlayer" "https://ldcdn.ldmnq.com/download/ldad/LDPlayer9.exe?n=LDPlayer9_ens_1001_ld.exe"
  }
  Register-Stamp "install-visipics" {
    Install-FromWeb "VisiPics" "https://altushost-swe.dl.sourceforge.net/project/visipics/VisiPics-1-31.exe"
  }
}
