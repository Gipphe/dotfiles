
[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

. "$Dirname\utils.ps1"
. "$Dirname\stamp.ps1"

$SDDir = "$Dirname\_temp"
Remove-Item -Force -Recurse -ErrorAction 'SilentlyContinue' -Path $SDDir
Invoke-Native { git clone https://codeberg.org/Gipphe/sd.git $SDDir }
. "$SDDir\sd.ps1" 
Remove-Item -Force -Recurse -ErrorAction 'SilentlyContinue' -Path $SDDir

