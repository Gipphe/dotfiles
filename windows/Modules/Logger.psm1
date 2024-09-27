#Requires -Version 5.1

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

class Logger {
  [Int]$IndentLevel = 0

  Logger([Int]$IndentLevel = 0) {
    $this.IndentLevel = $IndentLevel
  }

  [Void] Info([String]$Message) {
    Write-Information $Message.PadLeft($this.IndentLevel * 2)
  }

  [Logger] ChildLogger() {
    [Logger]::new($this.IndentLevel + 1)
  }
}

function New-Logger {
  [Logger]::new()
}

Export-ModuleMember -Function New-Logger
