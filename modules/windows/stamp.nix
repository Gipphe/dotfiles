{ lib, util, ... }:
util.mkModule {
  hm.gipphe.windows.powershell-script =
    lib.mkOrder (import ./order.nix).stamp # powershell
      ''
        class Stamp {
          [String]$STAMP
          [String]$sep

          Stamp([String]$Dirname) {
            $this.sep = [IO.Path]::DirectorySeparatorChar
            $this.STAMP = [IO.Path]::GetFullPath("''${Dirname}$($this.sep)..$($this.sep)..$($this.sep)STAMP")

            $this.Initialize()
          }

          [Void] Initialize() {
            if (-not (Test-Path -PathType Container -Path $this.STAMP)) {
              New-Item -ItemType Container -Path $this.STAMP
            }
          }

          [String] NewStampPath([String]$StampName) {
            return "$($this.STAMP)$($this.sep)''${StampName}"
          }

          [Void] Register([String]$StampName, [ScriptBlock]$Action) {
            $StampPath = $this.NewStampPath($StampName)

            if (Test-Path $StampPath) {
              return
            }

            & @Action
            New-Item -ItemType File $StampPath
          }
        }
        $Stamp = [Stamp]::new($PSScriptRoot)
      '';
}
