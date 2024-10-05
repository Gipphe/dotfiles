#Requires -Version 5.1
[CmdletBinding()]
param ()

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
    Write-Information "$($this.Indent($Message))"
  }
  [String] Indent([String]$Message) {
    $lines = $Message -split "`n" | ForEach-Object { "$(" " * $this.IndentLevel * 2)$_" }
    return $lines -join "`n"
  }

  [Logger] ChildLogger() {
    return [Logger]::new($this.IndentLevel + 1)
  }
}

$Logger = [Logger]::new()

function Install-FromWeb {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [String]$Name,

    [Parameter(Mandatory)]
    [String]$URI,

    [Parameter(Mandatory)]
    [PSCustomObject]$Logger
  )

  if (Test-IsInstalledInWinget $Name)
  {
    $this.Logger.Info("$Name is already installed")
    return
  }

  $this.Logger.Info(@(Invoke-WebRequest -URI $URI -OutFile "$HOME/Downloads/temp.exe"))

  Start-Process "$HOME/Downloads/temp.exe" -Wait
  Remove-Item "$HOME/Downloads/temp.exe"
  $this.Logger.Info("Installed $Name")
}

$script:WingetPrograms = $null

function Test-IsInstalledInWinget {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [String]$Name
  )

  if ($null -eq $script:WingetPrograms) {
    $script:WingetPrograms = $($(winget list).ToLower() -split "`n")
  }

  $Name = $Name.ToLower()

  foreach ($line in $script:WingetPrograms) {
    if ($line.StartsWith($Name)) {
      return $true
    }
  }
  return $false
}

function New-Shortcut {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [ValidateScript({ Test-Path $_ })]
    [String]$Source,

    [Parameter(Mandatory)]
    [String]$Destination,

    [Parameter(Mandatory)]
    [String]$Arguments,

    [Parameter(Mandatory)]
    [PSCustomObject]$Logger
  )

  $WshShell = New-Object -comObject WScript.Shell
  $Shortcut = $WshShell.CreateShortcut($Destination)
  $Shortcut.TargetPath = $Source
  $Shortcut.Arguments = $Arguments
  $Shortcut.Save()
  $this.Logger.Info("Created shortcut")
}

function Install-WithWinget {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [String]$Name
  )

  If (-Not (Test-IsInstalledInWinget $Name))
  {
    Invoke-Native { winget install --name $Name }
  }
}

function Invoke-Native {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [ScriptBlock]$ScriptBlock
  )

  & @ScriptBlock
  If ($LASTEXITCODE -Ne 0)
  {
    Write-Error "Non-zero exit code $LASTEXITCODE"
    Exit $LASTEXITCODE 
  }
}

class Stamp {
  [String]$STAMP
  [String]$sep

  Stamp([String]$Dirname) {
    $this.sep = [IO.Path]::DirectorySeparatorChar
    $this.STAMP = [IO.Path]::GetFullPath("${Dirname}$($this.sep)..$($this.sep)..$($this.sep)STAMP")

    $this.Initialize()
  }

  [Void] Initialize() {
    if (-not (Test-Path -PathType Container -Path $this.STAMP)) {
      New-Item -ItemType Container -Path $this.STAMP
    }
  }

  [String] NewStampPath([String]$StampName) {
    return "$($this.STAMP)$($this.sep)${StampName}"
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

class Choco {
  [PSCustomObject]$Logger

  Choco([PSCustomObject]$Logger) {
    $this.Logger = $Logger
    $this.EnsureInstalled()
  }

  [Void] EnsureInstalled() {
    try {
      Get-Command "choco" -ErrorAction Stop | Out-Null
    } catch {
      Set-ExecutionPolicy Bypass -Scope Process -Force
      [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
      Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
  }

  [Void] InstallApps() {
    $this.Logger.Info(" Installing Chocolatey programs...")
    $ChocoArgs = @('-y')
    $Installed = Invoke-Native { choco list --id-only }

    $ChocoApps = @(
      "7zip", "Everything", "barrier", "cursoride", "cyberduck", "discord", "docker-desktop", "dust", "epicgameslauncher", "everythingpowertoys", "filen", "firacodenf", "fzf", "gdlauncher", "geforce-experience", "git", "godot", "greenshot", "humble-app", "irfanview", "irfanview-languages", "irfanviewplugins", "k-litecodecpack-standard", "lghub", "libresprite", "logseq", "microsoft-windows-terminal", "msiafterburner", "notion", "nvidia-broadcast", "openssh", "paint.net", "powershell-core", "powertoys", "qbittorrent", "restic", "rsync", "slack", "spotify", "starship", "steam", "sumatrapdf", "sunshine", "teamviewer", "vcredist-all", "vivaldi", "voicemeeter", "wezterm", "windhawk", "windirstat", "xnviewmp", "zoxide", "7zip", "Everything", "barrier", "cursoride", "cyberduck", "discord", "docker-desktop", "dust", "epicgameslauncher", "everythingpowertoys", "filen", "firacodenf", "fzf", "gdlauncher", "geforce-experience", "git", "godot", "greenshot", "humble-app", "irfanview", "irfanview-languages", "irfanviewplugins", "k-litecodecpack-standard", "lghub", "libresprite", "logseq", "microsoft-windows-terminal", "msiafterburner", "notion", "nvidia-broadcast", "openssh", "paint.net", "powershell-core", "powertoys", "qbittorrent", "restic", "rsync", "slack", "spotify", "starship", "steam", "sumatrapdf", "sunshine", "teamviewer", "vcredist-all", "vivaldi", "voicemeeter", "wezterm", "windhawk", "windirstat", "xnviewmp", "zoxide"
    )

    $ChildLogger = $this.Logger.ChildLogger()

    $ChocoApps | ForEach-Object {
      $PackageName = $_
      $PackageArgs = $null
      if ($PackageName -isnot [String]) {
        $PackageName = $_[0]
        $PackageArgs = $_[1]
      }
      if ($Installed.Contains($PackageName)) {
        $ChildLogger.Info(" $PackageName is already installed")
        return
      }

      $params = ""
      if ($null -ne $PackageArgs) {
        $params = @("--params", $PackageArgs)
      }

      $ChildLogger.Info($(Invoke-Native { choco install @ChocoArgs $PackageName @params }))
      $ChildLogger.Info(" $PackageName installed.")
    }

    $this.Logger.Info(" Chocolatey programs installed.")
  }
}

$Choco = [Choco]::new($Logger)
$Choco.InstallApps()

