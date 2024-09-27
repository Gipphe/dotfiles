#Requires -Version 5.1

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

class Logger {
  [Int]$IndentLevel = 0

  Logger() {
    $this.IndentLevel = 0
  }

  Logger([Int]$IndentLevel) {
    $this.IndentLevel = $IndentLevel
  }

  [Void] Info([String]$Message) {
    Write-Information $($this.Indent($Message))
  }
  [String] Indent([String]$Message) {
    $lines = $Message -split "`n" | ForEach-Object { $_.PadLeft($this.IndentLevel * 2) }
    return $lines -join "`n"
  }

  [Logger] ChildLogger() {
    return [Logger]::new($this.IndentLevel + 1)
  }
}

function New-Logger {
  [Logger]::new()
}

Export-ModuleMember -Function New-Logger
