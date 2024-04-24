class SD {
  [PSCustomObject]$Utils
  [String]$Dirname

  SD() {
    $this.Dirname = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
    . "$($this.Dirname)\..\Utils.ps1"

    $this.Utils = New-Utils
  }

  [void] Install() {
    $SDDir = "$($this.Dirname)\_temp"
    Remove-Item -Force -Recurse -ErrorAction 'SilentlyContinue' -Path $SDDir
    $this.Utils.InvokeNative({ git clone https://codeberg.org/Gipphe/sd.git $SDDir })
    . "$SDDir\sd.ps1" 
    Remove-Item -Force -Recurse -ErrorAction 'SilentlyContinue' -Path $SDDir
  }
}

Function New-SD {
  [SD]::new()
}
