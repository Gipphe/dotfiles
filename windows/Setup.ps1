#Requires -Version 5.1
[CmdletBinding()]
param ()

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

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

class Config {
  [PSCustomObject]$Logger
  [String]$CfgDir

  Config([PSCustomObject]$Logger, [String]$Dirname) {
    $this.Logger = $Logger
    $this.CfgDir = "$Dirname/configs"
  }

  [Void] Install() {
    $this.Logger.Info(" Copying config files...")
    $ChildLogger = $this.Logger.ChildLogger()
    if ($null -eq $Env:HOME) {
      $Env:HOME = $Env:USERPROFILE
    }
    $HOME = $Env:HOME
    $Items = @(
      @("$($this.CfgDir)/.config-starship.toml", "$HOME/.config/starship.toml")

@("$($this.CfgDir)/.config-zoxide.ps1", "$HOME/.config/zoxide.ps1")

@("$($this.CfgDir)/.gitconfig", "$HOME/.gitconfig")

@("$($this.CfgDir)/.gitconfig_strise", "$HOME/.gitconfig_strise")

@("$($this.CfgDir)/.gitignore", "$HOME/.gitignore")

@("$($this.CfgDir)/.vimrc", "$HOME/.vimrc")

@("$($this.CfgDir)/.wslconfig", "$HOME/.wslconfig")

@("$($this.CfgDir)/AppData-Local-nvim-init.vim", "$HOME/AppData/Local/nvim/init.vim")

@("$($this.CfgDir)/Documents-PowerShell-Microsoft.PowerShell_profile.ps1", "$HOME/Documents/PowerShell/Microsoft.PowerShell_profile.ps1")

    )

    $Items | ForEach-Object {
      $From = $_[0]
      $To = $_[1]

      # Ensure parent dir exists
      $ToDir = Split-Path -Parent $To
      if (-not (Test-Path -PathType Container $ToDir)) {
        New-Item -Force -ItemType Directory $ToDir
      }

      # Clean out existing destination if it is a directory. Otherwise, we'll
      # end up copying _into_ the existing directory.
      if (Test-Path -PathType Container $To) {
        Remove-Item -Recurse -Force $To
      }

      Copy-Item -Force -Recurse -Path $From -Destination $To
      $FileName = Split-Path -Leaf $From
      $ChildLogger.Info(" $FileName copied")
    }

    $this.Logger.Info(" Config files copied.")
  }
}

$Config = [Config]::new($Logger, $PSScriptRoot)
$Config.Install()

class Env {
  [PSCustomObject]$Logger
  
  Env([PSCustomObject]$Logger) {
    $this.Logger = $Logger
  }
  [Void] Install() {
    $this.Logger.Info(" Setting env vars...")
    $ChildLogger = $this.Logger.ChildLogger()
    $EnvVars = @{
      'XDG_CONFIG_HOME' = $Env:USERPROFILE/.config
    }
    $EnvVars.GetEnumerator() | ForEach-Object {
      $key = $_.Key
      $val = $_.Value
      [Environment]::SetEnvironmentVariable($key, $val, 'User')
      $ChildLogger.Info(" $key env var set")
    }
    $this.Logger.Info(" Env vars set.")
  }
}
$Env = [Env]::new($Logger)
$Env.Install()

class Programs {
  [PSCustomObject]$Logger
  [PSCustomObject]$Stamp

  Programs([PSCustomObject]$Logger, [PSCustomObject]$Stamp) {
    $this.Logger = $Logger
    $this.Stamp = $Stamp
  }

  [void] Install() {
    $this.Logger.Info(" Installing manually installed programs...")

    $ChildLogger = $this.Logger.ChildLogger()

    $this.Stamp.Register("install-1password", {
  Install-FromWeb "1Password" "https://downloads.1password.com/win/1PasswordSetup-latest.exe" $ChildLogger
})

$this.Stamp.Register("install-firefox-developer-edition", {
  Install-FromWeb "Firefox Developer Edition" "https://download-installer.cdn.mozilla.net/pub/devedition/releases/120.0b4/win32/en-US/Firefox%20Installer.exe" $ChildLogger
})

$this.Stamp.Register("install-ldplayer", {
  Install-FromWeb "LDPlayer" "https://ldcdn.ldmnq.com/download/ldad/LDPlayer9.exe?n=LDPlayer9_ens_1001_ld.exe" $ChildLogger
})

$this.Stamp.Register("install-visipics", {
  Install-FromWeb "VisiPics" "https://altushost-swe.dl.sourceforge.net/project/visipics/VisiPics-1-31.exe" $ChildLogger
})


    $this.Logger.Info(" Programs installed.")
  }
}
$Programs = [Programs]::new($Logger, $Stamp)
$Programs.Install()

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
      "7zip", "Everything", "barrier", "cursoride", "cyberduck", "discord", "docker-desktop", "dust", "epicgameslauncher", "everythingpowertoys", "filen", "firacodenf", "fzf", "gdlauncher", "geforce-experience", "git", "godot", "greenshot", "humble-app", "irfanview", "irfanview-languages", "irfanviewplugins", "k-litecodecpack-standard", "lghub", "libresprite", "logseq", "microsoft-windows-terminal", "msiafterburner", "notion", "nvidia-broadcast", "openssh", "paint.net", "powershell-core", "powertoys", "qbittorrent", "restic", "rsync", "slack", "spotify", "starship", "steam", "sumatrapdf", "sunshine", "teamviewer", "vcredist-all", "vivaldi", "voicemeeter", "wezterm", "windhawk", "windirstat", "xnviewmp", "zoxide", @("firefox-dev", "--pre"), "7zip", "Everything", "barrier", "cursoride", "cyberduck", "discord", "docker-desktop", "dust", "epicgameslauncher", "everythingpowertoys", "filen", "firacodenf", "fzf", "gdlauncher", "geforce-experience", "git", "godot", "greenshot", "humble-app", "irfanview", "irfanview-languages", "irfanviewplugins", "k-litecodecpack-standard", "lghub", "libresprite", "logseq", "microsoft-windows-terminal", "msiafterburner", "notion", "nvidia-broadcast", "openssh", "paint.net", "powershell-core", "powertoys", "qbittorrent", "restic", "rsync", "slack", "spotify", "starship", "steam", "sumatrapdf", "sunshine", "teamviewer", "vcredist-all", "vivaldi", "voicemeeter", "wezterm", "windhawk", "windirstat", "xnviewmp", "zoxide", @("firefox-dev", "--pre")
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

class Scoop {
  [PSCustomObject]$Logger
  
  Scoop([PSCustomObject]$Logger) {
    $this.Logger = $Logger
    $this.EnsureInstalled()
  }

  [Void] EnsureInstalled() {
    try {
      Get-Command "scoop" -ErrorAction Stop
    } catch {
      Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
      Invoke-RestMethod -Uri "https://get.scoop.sh" | Invoke-Expression
    }
  }

  [Void] InstallApps() {
    $this.Logger.Info(" Installing scoop programs...")
    $ChildLogger = $this.Logger.ChildLogger()
    $InstalledBuckets = Invoke-Native { scoop bucket list 6>$Null } | ForEach-Object { $_.Name }
    $InstalledApps = Invoke-Native { scoop list 6>$Null } | ForEach-Object { $_.Name }

    $RequiredBuckets = @(
      "extras", "extras"
    )
    $RequiredApps = @(
      "direnv", "ffmpeg", "neovide", "neovim", "stash", "direnv", "ffmpeg", "neovide", "neovim", "stash"
    )

    $RequiredBuckets | ForEach-Object {
      $BucketName = $_

      if (-not ($InstalledBuckets.Contains($BucketName))) {
        $ChildLogger.Info($(Invoke-Native { scoop bucket add $BucketName }))
      }

      $ChildLogger.Info(" $BucketName bucket installed.")
    }

    $RequiredApps | ForEach-Object {
      $PackageName = $_

      if (-not ($InstalledApps.Contains($PackageName))) {
        $ChildLogger.Info($(Invoke-Native { scoop install $PackageName }))
      }

      $ChildLogger.Info(" $PackageName package installed.")
    }

    $this.Logger.Info(" Scoop programs installed.")
  }
}
$Scoop = [Scoop]::new($Logger)
$Scoop.InstallApps()

class Registry {
  [PSCustomObject]$Logger
  [PSCustomObject]$Stamp

  Registry([PSCustomObject]$Logger) {
    $this.Logger = $Logger
    $this.Stamp = New-Stamp
  }

  [Void] StampEntry([PSCustomObject]$ChildLogger, [String]$Stamp, [String]$Path, [String]$Entry, [String]$Type, [String]$Data) {
    $this.Stamp.Register($Stamp, {
      $ChildLogger.Info("Setting $Path\$Entry")
      reg add "$Path" /v "$Entry" /t "$Type" /d $Data /f
    })
  }

  [Void] SetEntries() {
    $this.Logger.Info(" Setting registry entries...")
    $ChildLogger = $this.Logger.ChildLogger()

    # Use checkboxes for selecting files
$this.StampEntry(
  $ChildLogger,
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAdvanced-AutoCheckSelect",
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAdvanced",
  "AutoCheckSelect",
  "REG_DWORD",
  "1"
)

# Show hidden files
$this.StampEntry(
  $ChildLogger,
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAdvanced-Hidden",
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAdvanced",
  "Hidden",
  "REG_DWORD",
  "1"
)

# Always show file extensions
$this.StampEntry(
  $ChildLogger,
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAdvanced-HideFileExt",
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAdvanced",
  "HideFileExt",
  "REG_DWORD",
  "0"
)

# Search files and folders in the Start Menu
$this.StampEntry(
  $ChildLogger,
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAdvanced-Start_SearchFiles",
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAdvanced",
  "Start_SearchFiles",
  "REG_DWORD",
  "2"
)

# Disable UAC for all users
$this.StampEntry(
  $ChildLogger,
  "HKLMSoftwareMicrosoftWindowsCurrentVersionPoliciesSystem-EnableLUA",
  "HKLMSoftwareMicrosoftWindowsCurrentVersionPoliciesSystem",
  "EnableLUA",
  "REG_DWORD",
  "0"
)

# 
$this.StampEntry(
  $ChildLogger,
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAccent-AccentColorMenu",
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAccent",
  "AccentColorMenu",
  "REG_DWORD",
  "4290274439"
)

# 
$this.StampEntry(
  $ChildLogger,
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAccent-AcceptPalette",
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAccent",
  "AcceptPalette",
  "REG_BINARY",
  "d4b5ff00c096fa00a882dd008764b8005b3e83003c2759002b1c40008e8cd800"
)

# 
$this.StampEntry(
  $ChildLogger,
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAccent-StartColorMenu",
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAccent",
  "StartColorMenu",
  "REG_DWORD",
  "4286791259"
)

# Disable keyboard layout hotkeys
$this.StampEntry(
  $ChildLogger,
  "HKCUKeyboard Layout-Toggle-Hotkey",
  "HKCUKeyboard Layout/Toggle",
  "Hotkey",
  "REG_SZ",
  "3"
)

# 
$this.StampEntry(
  $ChildLogger,
  "HKCUKeyboard Layout-Toggle-Language Hotkey",
  "HKCUKeyboard Layout/Toggle",
  "Language Hotkey",
  "REG_SZ",
  "3"
)

# 
$this.StampEntry(
  $ChildLogger,
  "HKCUKeyboard Layout-Toggle-Layout Hotkey",
  "HKCUKeyboard Layout/Toggle",
  "Layout Hotkey",
  "REG_SZ",
  "3"
)

# Disable Taskbar Search bar
$this.StampEntry(
  $ChildLogger,
  "HKEY_CURRENT_USERSOFTWAREMicrosoftWindowsCurrentVersionSearch-SearchboxTaskbarMode",
  "HKEY_CURRENT_USERSOFTWAREMicrosoftWindowsCurrentVersionSearch",
  "SearchboxTaskbarMode",
  "REG_DWORD",
  "0"
)

# Disable News and Interests from Start Menu
$this.StampEntry(
  $ChildLogger,
  "HKEY_CURRENT_USERSOFTWAREMicrosoftWindowsCurrentVersionFeeds-ShellFeedsTaskbarViewMode",
  "HKEY_CURRENT_USERSOFTWAREMicrosoftWindowsCurrentVersionFeeds",
  "ShellFeedsTaskbarViewMode",
  "REG_DWORD",
  "2"
)

# Hide Task View button from Taskbar
$this.StampEntry(
  $ChildLogger,
  "HKEY_CURRENT_USERSOFTWAREMicrosoftWindowsCurrentVersionExplorerAdvanced-ShowTaskViewButton",
  "HKEY_CURRENT_USERSOFTWAREMicrosoftWindowsCurrentVersionExplorerAdvanced",
  "ShowTaskViewButton",
  "REG_DWORD",
  "0"
)

# Use small icons in Taskbar
$this.StampEntry(
  $ChildLogger,
  "HKEY_CURRENT_USERSOFTWAREMicrosoftWindowsCurrentVersionExplorerAdvanced-TaskbarSmallIcons",
  "HKEY_CURRENT_USERSOFTWAREMicrosoftWindowsCurrentVersionExplorerAdvanced",
  "TaskbarSmallIcons",
  "REG_DWORD",
  "1"
)

# Don't collapse taskbar items until taskbar is full
$this.StampEntry(
  $ChildLogger,
  "HKEY_CURRENT_USERSOFTWAREMicrosoftWindowsCurrentVersionExplorerAdvanced-TaskbarGlomLevel",
  "HKEY_CURRENT_USERSOFTWAREMicrosoftWindowsCurrentVersionExplorerAdvanced",
  "TaskbarGlomLevel",
  "REG_DWORD",
  "1"
)

# Lock taskbar
$this.StampEntry(
  $ChildLogger,
  "HKEY_CURRENT_USERSOFTWAREMicrosoftWindowsCurrentVersionExplorerAdvanced-TaskbarSizeMove",
  "HKEY_CURRENT_USERSOFTWAREMicrosoftWindowsCurrentVersionExplorerAdvanced",
  "TaskbarSizeMove",
  "REG_DWORD",
  "0"
)

# Show all icons in notification area
$this.StampEntry(
  $ChildLogger,
  "HKEY_CURRENT_USERSOFTWAREMicrosoftWindowsCurrentVersionExplorer-EnableAutoTray",
  "HKEY_CURRENT_USERSOFTWAREMicrosoftWindowsCurrentVersionExplorer",
  "EnableAutoTray",
  "REG_DWORD",
  "0"
)

# Set window colors
$this.StampEntry(
  $ChildLogger,
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAccent-AccentColorMenu",
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAccent",
  "AccentColorMenu",
  "REG_DWORD",
  "ffb86487"
)

# 
$this.StampEntry(
  $ChildLogger,
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAccent-StartColorMenu",
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAccent",
  "StartColorMenu",
  "REG_DWORD",
  "ff833e5b"
)

# Use checkboxes for selecting files
$this.StampEntry(
  $ChildLogger,
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAdvanced-AutoCheckSelect",
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAdvanced",
  "AutoCheckSelect",
  "REG_DWORD",
  "1"
)

# Show hidden files
$this.StampEntry(
  $ChildLogger,
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAdvanced-Hidden",
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAdvanced",
  "Hidden",
  "REG_DWORD",
  "1"
)

# Always show file extensions
$this.StampEntry(
  $ChildLogger,
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAdvanced-HideFileExt",
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAdvanced",
  "HideFileExt",
  "REG_DWORD",
  "0"
)

# Search files and folders in the Start Menu
$this.StampEntry(
  $ChildLogger,
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAdvanced-Start_SearchFiles",
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAdvanced",
  "Start_SearchFiles",
  "REG_DWORD",
  "2"
)

# Disable UAC for all users
$this.StampEntry(
  $ChildLogger,
  "HKLMSoftwareMicrosoftWindowsCurrentVersionPoliciesSystem-EnableLUA",
  "HKLMSoftwareMicrosoftWindowsCurrentVersionPoliciesSystem",
  "EnableLUA",
  "REG_DWORD",
  "0"
)

# 
$this.StampEntry(
  $ChildLogger,
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAccent-AccentColorMenu",
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAccent",
  "AccentColorMenu",
  "REG_DWORD",
  "4290274439"
)

# 
$this.StampEntry(
  $ChildLogger,
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAccent-AcceptPalette",
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAccent",
  "AcceptPalette",
  "REG_BINARY",
  "d4b5ff00c096fa00a882dd008764b8005b3e83003c2759002b1c40008e8cd800"
)

# 
$this.StampEntry(
  $ChildLogger,
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAccent-StartColorMenu",
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAccent",
  "StartColorMenu",
  "REG_DWORD",
  "4286791259"
)

# Disable keyboard layout hotkeys
$this.StampEntry(
  $ChildLogger,
  "HKCUKeyboard Layout-Toggle-Hotkey",
  "HKCUKeyboard Layout/Toggle",
  "Hotkey",
  "REG_SZ",
  "3"
)

# 
$this.StampEntry(
  $ChildLogger,
  "HKCUKeyboard Layout-Toggle-Language Hotkey",
  "HKCUKeyboard Layout/Toggle",
  "Language Hotkey",
  "REG_SZ",
  "3"
)

# 
$this.StampEntry(
  $ChildLogger,
  "HKCUKeyboard Layout-Toggle-Layout Hotkey",
  "HKCUKeyboard Layout/Toggle",
  "Layout Hotkey",
  "REG_SZ",
  "3"
)

# Disable Taskbar Search bar
$this.StampEntry(
  $ChildLogger,
  "HKEY_CURRENT_USERSOFTWAREMicrosoftWindowsCurrentVersionSearch-SearchboxTaskbarMode",
  "HKEY_CURRENT_USERSOFTWAREMicrosoftWindowsCurrentVersionSearch",
  "SearchboxTaskbarMode",
  "REG_DWORD",
  "0"
)

# Disable News and Interests from Start Menu
$this.StampEntry(
  $ChildLogger,
  "HKEY_CURRENT_USERSOFTWAREMicrosoftWindowsCurrentVersionFeeds-ShellFeedsTaskbarViewMode",
  "HKEY_CURRENT_USERSOFTWAREMicrosoftWindowsCurrentVersionFeeds",
  "ShellFeedsTaskbarViewMode",
  "REG_DWORD",
  "2"
)

# Hide Task View button from Taskbar
$this.StampEntry(
  $ChildLogger,
  "HKEY_CURRENT_USERSOFTWAREMicrosoftWindowsCurrentVersionExplorerAdvanced-ShowTaskViewButton",
  "HKEY_CURRENT_USERSOFTWAREMicrosoftWindowsCurrentVersionExplorerAdvanced",
  "ShowTaskViewButton",
  "REG_DWORD",
  "0"
)

# Use small icons in Taskbar
$this.StampEntry(
  $ChildLogger,
  "HKEY_CURRENT_USERSOFTWAREMicrosoftWindowsCurrentVersionExplorerAdvanced-TaskbarSmallIcons",
  "HKEY_CURRENT_USERSOFTWAREMicrosoftWindowsCurrentVersionExplorerAdvanced",
  "TaskbarSmallIcons",
  "REG_DWORD",
  "1"
)

# Don't collapse taskbar items until taskbar is full
$this.StampEntry(
  $ChildLogger,
  "HKEY_CURRENT_USERSOFTWAREMicrosoftWindowsCurrentVersionExplorerAdvanced-TaskbarGlomLevel",
  "HKEY_CURRENT_USERSOFTWAREMicrosoftWindowsCurrentVersionExplorerAdvanced",
  "TaskbarGlomLevel",
  "REG_DWORD",
  "1"
)

# Lock taskbar
$this.StampEntry(
  $ChildLogger,
  "HKEY_CURRENT_USERSOFTWAREMicrosoftWindowsCurrentVersionExplorerAdvanced-TaskbarSizeMove",
  "HKEY_CURRENT_USERSOFTWAREMicrosoftWindowsCurrentVersionExplorerAdvanced",
  "TaskbarSizeMove",
  "REG_DWORD",
  "0"
)

# Show all icons in notification area
$this.StampEntry(
  $ChildLogger,
  "HKEY_CURRENT_USERSOFTWAREMicrosoftWindowsCurrentVersionExplorer-EnableAutoTray",
  "HKEY_CURRENT_USERSOFTWAREMicrosoftWindowsCurrentVersionExplorer",
  "EnableAutoTray",
  "REG_DWORD",
  "0"
)

# Set window colors
$this.StampEntry(
  $ChildLogger,
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAccent-AccentColorMenu",
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAccent",
  "AccentColorMenu",
  "REG_DWORD",
  "ffb86487"
)

# 
$this.StampEntry(
  $ChildLogger,
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAccent-StartColorMenu",
  "HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAccent",
  "StartColorMenu",
  "REG_DWORD",
  "ff833e5b"
)


    $AutoLoginEnabled = $False
try {
  $Prop = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'AutoAdminLogon'
  $Prop
  $AutoLoginEnabled = $Prop.AutoAdminLogon -eq '1'
  $AutoLoginEnabled
} catch { }

if (-not $AutoLoginEnabled) {
  $Username = Read-Host "Enter username for auto-login"
  $Password = Read-Host "Enter password for auto-login" -AsSecureString

  # Convert SecureString password to plain text
  $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
  $PlainPass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

  # Set registry keys
  Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'DefaultUserName' -Value $Username
  Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'DefaultPassword' -Value $PlainPass
  Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'AutoAdminLogon' -Value '1'

  # Cleanup
  [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
}


    $this.Logger.Info(" Registry entries set.")
  }
}

class SD {
  [PSCustomObject]$Logger
  [String]$Dirname

  SD([PSCustomObject]$Logger, [String]$Dirname) {
    $this.Logger = $Logger
    $this.Dirname = $Dirname
  }

  [Void] Install() {
    $this.Logger.Info(" Setting up SD...")
    $ChildLogger = $this.Logger.ChildLogger()
    $SDDir = "$($this.Dirname)\_temp"
    Remove-Item -Force -Recurse -ErrorAction 'SilentlyContinue' -Path $SDDir
    try {
      $ChildLogger.Info($(Invoke-Native { git clone "https://codeberg.org/Gipphe/sd.git" "$SDDir" }))
      try {
        Push-Location $SDDir
        $ChildLogger.Info($(Invoke-Native { pwsh .\sd.ps1 }))
        Pop-Location
      } catch {
        Pop-Location
        throw $error
      }
      $ChildLogger.Info(" SD repo downloaded and initialized.")
    } catch {
      $this.Logger.ChildLogger().Info("Failed to setup SD")
    } finally {
      Remove-Item -Force -Recurse -ErrorAction 'SilentlyContinue' -Path $SDDir
    }
    $this.Logger.Info(" SD set up.")
  }
}
$SD = [SD]::new($Logger, $PSScriptRoot)
$SD.Install()

class WSL {
  [PSCustomObject]$Logger
  [PSCustomObject]$Stamp

  WSL([PSCustomObject]$Logger, [PSCustomObject]$Stamp) {
    $this.Logger = $Logger
    $this.Stamp = $Stamp
  }

  [Void] Install() {
    $this.Logger.Info(" Installing and setting up WSL...")
    $ChildLogger = $this.Logger.ChildLogger()
    $this.Stamp.Register("install-wsl", {
      $ChildLogger.Info($(Invoke-Native { wsl --install }))
    })

    $this.Stamp.Register("install-nixos-wsl", {
      $ChildLogger.Info($(Invoke-WebRequest `
        -Uri "https://github.com/nix-community/NixOS-WSL/releases/download/2311.5.3/nixos-wsl.tar.gz" `
        -OutFile "$HOME\Downloads\nixos-wsl.tar.gz" `
      ))
      $ChildLogger.Info($(Invoke-Native { wsl --import "NixOS" "$HOME\NixOS\" "$HOME\Downloads\nixos-wsl.tar.gz" }))
      $ChildLogger.Info($(Invoke-Native { wsl --set-default "NixOS" }))
    })

    $this.Stamp.Register("configure-nixos", {
      $ChildLogger.Info($(Invoke-Native {
        wsl -d "NixOS" -- `
          ! test -s '$HOME/projects/dotfiles' `
          '&&' nix-shell -p git --run '"git clone https://codeberg.org/Gipphe/dotfiles.git"' '"$HOME/projects/dotfiles"' `
          '&&' cd '$HOME/projects/dotfiles' `
          '&&' nixos-rebuild --extra-experimental-features 'flakes nix-command' switch --flake '"$(pwd)#Jarle"'
      }))
    })
    $this.Logger.Info(" WSL installed and set up.")
  }
}
$WSL = [WSL]::new($Logger, $Stamp)
$WSL.Install()

