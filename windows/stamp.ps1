[CmdletBinding()]
Param ()

$STAMP = "$dirname\STAMP"

Function Initialize-Stamp
{
  [CmdletBinding()]
  Param ()
    
  If (-Not (Test-Path -PathType Container -Path $STAMP))
  {
    New-Item -ItemType Container -Path $STAMP
  }
}

Function New-StampPath
{
  [CmdletBinding()]
  Param (
    [Parameter(Mandatory)]
    [String]$StampName
  )
  
  "$STAMP/$StampName"
}

Function Register-Stamp
{
  [CmdletBinding()]
  Param (
    [Parameter(Mandatory)]
    [String]$StampName,

    [Parameter(Mandatory)]
    [ScriptBlock]$Action
  )

  $StampPath = New-StampPath $StampName

  If (Test-Path $StampPath)
  {
    Return
  }

  & @Action
  New-Item -ItemType File $StampPath
}
