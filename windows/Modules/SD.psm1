#Requires -Version 7.3

Import-Module $PSScriptRoot/Utils.psm1

$ErrorActionPreference = "Stop"

class SD {
  [String]$Dirname

  SD([String]$Dirname) {
    $this.Dirname = $Dirname
  }

  [Void] Install() {
    $SDDir = "$($this.Dirname)\_temp"
    Remove-Item -Force -Recurse -ErrorAction 'SilentlyContinue' -Path $SDDir
    Invoke-Native { git clone https://codeberg.org/Gipphe/sd.git $SDDir } 
    . "$SDDir\sd.ps1" 
    Remove-Item -Force -Recurse -ErrorAction 'SilentlyContinue' -Path $SDDir
  }
}

Function New-SD {
  [SD]::new($PSScriptRoot)
}

Export-ModuleMember -Function New-SD
