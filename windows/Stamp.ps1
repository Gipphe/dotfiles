class Stamp {
  [String]$STAMP

  Stamp() {
    $Dirname = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
    $this.STAMP = "$Dirname\..\STAMP"

    $this.Initialize()
  }

  [void] Initialize() {
    If (-Not (Test-Path -PathType Container -Path $this.STAMP))
    {
      New-Item -ItemType Container -Path $this.STAMP
    }
  }

  [String] NewStampPath([String]$StampName) {
    "$STAMP/$StampName"
  }

  [void] Register([String]$StampName, [ScriptBlock]$Action) {
    $StampPath = $this.NewStampPath $StampName

    If (Test-Path $StampPath)
    {
      Return
    }

    & @Action
    New-Item -ItemType File $StampPath
  }
}
