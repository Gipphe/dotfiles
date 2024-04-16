[CmdletBinding()]
Param()

$ErrorActionPreference = "Stop"

Function Install-Config
{
  [CmdletBinding()]
  Param ()

  Copy-Item -Path "$dirname\..\config\.vimrc" -Destination "$HOME\.vimrc"
}
