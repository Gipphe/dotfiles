#Requires -Version 5.1

Import-Module $PSScriptRoot/Utils.psm1

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

class SD {
  [String]$Dirname

  SD([String]$Dirname) {
    $this.Dirname = $Dirname
  }

  [Void] Install() {
    Write-Information " Setting up SD..."
    $SDDir = "$($this.Dirname)\_temp"
    Remove-Item -Force -Recurse -ErrorAction 'SilentlyContinue' -Path $SDDir
    try {
      Invoke-Native { git clone "https://codeberg.org/Gipphe/sd.git" "$SDDir" }
      . "$SDDir\sd.ps1"
    } catch {
      echo "Failed to setup SD"
    } finally {
      Remove-Item -Force -Recurse -ErrorAction 'SilentlyContinue' -Path $SDDir
    }
    Write-Information " SD set up."
  }
}

Function New-SD {
  [SD]::new($PSScriptRoot)
}

Export-ModuleMember -Function New-SD
