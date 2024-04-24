class SD {
  [PSCustomObject]$Utils
  [String]$Dirname

  SD() {
    $this.Dirname = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
    Using module "$($this.Dirname)\..\Utils.psm1"

    $this.Utils = [Utils]::new()
  }

  [void] Install() {
    $SDDir = "$($this.Dirname)\_temp"
    Remove-Item -Force -Recurse -ErrorAction 'SilentlyContinue' -Path $SDDir
    $this.Utils.InvokeNative({ git clone https://codeberg.org/Gipphe/sd.git $SDDir })
    . "$SDDir\sd.ps1" 
    Remove-Item -Force -Recurse -ErrorAction 'SilentlyContinue' -Path $SDDir
  }
}

