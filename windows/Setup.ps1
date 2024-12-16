#Requires -Version 5.1
[CmdletBinding()]
param ()

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

try {

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

function Resolve-PathNice {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [String]$Path
  )

  return $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
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
    $this.STAMP = [IO.Path]::GetFullPath("${Dirname}$($this.sep)STAMP")

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
    $baseUrl = $Env:USERPROFILE
    $Items = Get-ChildItem -File -Recurse "$($this.CfgDir)" | Resolve-Path -Relative -RelativeBasePath "$($this.CfgDir)"

    $Items | ForEach-Object {
      $From = Resolve-PathNice "$($this.CfgDir)/$_"
      $To = Resolve-PathNice "$baseUrl/$_"

      # Ensure parent dir exists
      $ToDir = Split-Path -Parent $To
      if (-not (Test-Path -PathType Container $ToDir)) {
        New-Item -Force -ItemType Directory $ToDir
      }

      # Clean out existing destination if it is a directory. Otherwise, we'll
      # end up copying _into_ the existing directory.
      if (Test-Path -PathType Container $To) {
        Write-Host "Would have deleted $To because it is a directory"
        continue
        # Remove-Item -Recurse -Force $To
      }

      Copy-Item -Force -Recurse -Path $From -Destination $To
      $FileName = Split-Path -Leaf $From
      $ChildLogger.Info(" $_ copied")
    }

    $this.Logger.Info(" Config files copied.")
  }
}

$Config = [Config]::new($Logger, $PSScriptRoot)
$Config.Install()

class Download {
  [PSCustomObject]$Logger

  Download([PSCustomObject]$Logger) {
    $this.Logger = $Logger
  }

  [Void] Install() {
    $this.Logger.Info(" Downloading files...")
    $ChildLogger = $this.Logger.ChildLogger()
    $DestDir = $Env:USERPROFILE

    if (Test-Path "$DestDir/.local/bin/filen.exe") {
  $ChildLogger.Info(" $DestDir/.local/bin/filen.exe already downloaded.")
} else {
  $ChildLogger.Info(" Downloading https://github.com/FilenCloudDienste/filen-cli/releases/download/v0.0.24/filen-cli-v0.0.24-win-x64.exe...")
  New-Item -ItemType Container -Path (Split-Path -Parent "$DestDir/.local/bin/filen.exe")
  Invoke-WebRequest -Uri "https://github.com/FilenCloudDienste/filen-cli/releases/download/v0.0.24/filen-cli-v0.0.24-win-x64.exe" -OutFile "$DestDir/.local/bin/filen.exe"
  $ChildLogger.Info(" Downloaded https://github.com/FilenCloudDienste/filen-cli/releases/download/v0.0.24/filen-cli-v0.0.24-win-x64.exe")
}


    $this.Logger.Info(" Files downloaded.")
  }
}

$Download = [Download]::new($Logger)
$Download.Install()

class Env {
  [PSCustomObject]$Logger
  
  Env([PSCustomObject]$Logger) {
    $this.Logger = $Logger
  }
  [Void] Install() {
    $this.Logger.Info(" Setting env vars...")
    $ChildLogger = $this.Logger.ChildLogger()
    $EnvVars = @{
      'XDG_CONFIG_HOME' = "$($Env:USERPROFILE)\\.config";
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

    $Programs = @{ 'Hurl' = @{
  'URI' = 'https://github.com/U-C-S/Hurl/releases/download/v0.9.0/Hurl_Installer.exe'
  'stamp' = 'install-hurl'
};

'LDPlayer' = @{
  'URI' = 'https://ldcdn.ldmnq.com/download/ldad/LDPlayer9.exe?n=LDPlayer9_ens_1001_ld.exe'
  'stamp' = 'install-ldplayer'
};

'VisiPics' = @{
  'URI' = 'https://altushost-swe.dl.sourceforge.net/project/visipics/VisiPics-1-31.exe'
  'stamp' = 'install-visipics'
};

'Windows App SDK' = @{
  'URI' = 'https://aka.ms/windowsappsdk/1.5/1.5.241001000/windowsappruntimeinstall-x64.exe'
  'stamp' = 'install-windows-app-sdk'
};
}

    $Programs.GetEnumerator() | ForEach-Object {
      $Name = $_.Key
      $URI = $_.Val.URI
      $StampName = $_.Val.stamp
      $this.Stamp.Register("$StampName", {
        Install-FromWeb "$Name" "$URI" $ChildLogger
      })
    }

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
      "signal", "jetbrains-rider", "godot-mono", "dotnet-8.0-sdk", "floorp", "1password", "7zip", "barrier", "cursoride", "discord", "docker-desktop", "dust", "epicgameslauncher", "filen", "filezilla", "firacodenf", "floorp", "fzf", "gdlauncher", "geforce-experience", "git", "greenshot", "humble-app", "irfanview", "irfanview-languages", "irfanviewplugins", "k-litecodecpack-standard", "lghub", "libresprite", "logseq", "microsoft-windows-terminal", "msiafterburner", "notion", "nvidia-broadcast", "openssh", "paint.net", "powershell-core", "powertoys", "qbittorrent", "restic", "rsync", "slack", "spotify", "starship", "steam", "sumatrapdf", "sunshine", "teamviewer", "vcredist-all", "voicemeeter", "wezterm", "windhawk", "windirstat", "xnviewmp", "zoxide", @("opera-gx", "--params='`"/NoDesktopShortcut /NoTaskbarShortcut`"'")
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
        $params = $PackageArgs
      }

      $ChildLogger.Info($(Invoke-Native { choco install @ChocoArgs $PackageName $params }))
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
      "extras"
    )
    $RequiredApps = @(
      "direnv", "ffmpeg", "neovide", "neovim", "stash"
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
      Invoke-Native { git clone "https://codeberg.org/Gipphe/sd.git" "$SDDir" }
      if (-not (Test-Path -PathType Container "$SDDir")) {
        $ChildLogger.Info("✗ $SDDir does not exist, even though we _just_ cloned into it.")
        return
      }
      try {
        Push-Location $SDDir
        Invoke-Native { pwsh .\sd.ps1 }
        Pop-Location
      } catch {
        Pop-Location
        throw $error[0]
      }
      $ChildLogger.Info(" SD repo downloaded and initialized.")
    } catch {
      $ChildLogger.Info("✗ Failed to setup SD")
      $ChildLogger.Info($error[0])
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

    $ChildLogger.Info(" Install WSL")
    $this.Stamp.Register("install-wsl", {
      $ChildLogger.Info($(Invoke-Native { wsl --install }))
    })
    $ChildLogger.Info(" WSL installed")

    $ChildLogger.Info(" Install nixos-wsl image")
    $this.Stamp.Register("install-nixos-wsl", {
      $ChildLogger.Info($(Invoke-WebRequest `
        -Uri "https://github.com/nix-community/NixOS-WSL/releases/download/2311.5.3/nixos-wsl.tar.gz" `
        -OutFile "$HOME\Downloads\nixos-wsl.tar.gz" `
      ))
      $ChildLogger.Info($(Invoke-Native { wsl --import "NixOS" "$HOME\NixOS\" "$HOME\Downloads\nixos-wsl.tar.gz" }))
      $ChildLogger.Info($(Invoke-Native { wsl --set-default "NixOS" }))
    })
    $ChildLogger.Info(" nixos-wsl installed")

    $ChildLogger.Info(" Configure nixos-wsl")
    $this.Stamp.Register("configure-nixos", {
      $ChildLogger.Info($(Invoke-Native {
        wsl -d "NixOS" -- `
          ! test -s '$HOME/projects/dotfiles' `
          '&&' nix-shell -p git --run '"git clone https://codeberg.org/Gipphe/dotfiles.git"' '"$HOME/projects/dotfiles"' `
          '&&' cd '$HOME/projects/dotfiles' `
          '&&' nixos-rebuild --extra-experimental-features 'flakes nix-command' switch --flake '"$(pwd)#argon"'
      }))
    })
    $ChildLogger.Info(" nixos-wsl configured")
    $this.Logger.Info(" WSL installed and set up.")
  }
}
$WSL = [WSL]::new($Logger, $Stamp)
$WSL.Install()

class FS22 {
  [PSCustomObject]$Logger
  [String]$FS22ModDir
  [String[]]$FS22Mods

  FS22([PSCustomObject]$Logger) {
    $this.Logger = $Logger
    $baseUrl = $Env:USERPROFILE
    $this.FS22ModDir = "$baseUrl/Documents/My Games/FarmingSimulator2022/mods"

    $this.FS22Mods = @(
      "https://cdn10.giants-software.com/modHub/storage/00225543/FS22_additionalCurrencies.zip", "https://cdn10.giants-software.com/modHub/storage/00226183/FS22_DeutzSeries7_8.zip", "https://cdn10.giants-software.com/modHub/storage/00227409/FS22_viconAndex1304Pro.zip", "https://cdn10.giants-software.com/modHub/storage/00228105/FS22_airHoseConnectSound.zip", "https://cdn10.giants-software.com/modHub/storage/00228206/FS22_LandBakery.zip", "https://cdn10.giants-software.com/modHub/storage/00228541/FS22_poettingerNovaDiscPack.zip", "https://cdn10.giants-software.com/modHub/storage/00228604/FS22_realDirtColor.zip", "https://cdn10.giants-software.com/modHub/storage/00228656/FS22_TLX2020_Series.zip", "https://cdn10.giants-software.com/modHub/storage/00228771/FS22_Profihopper.zip", "https://cdn10.giants-software.com/modHub/storage/00229254/FS22_claasDiscoPack.zip", "https://cdn10.giants-software.com/modHub/storage/00230002/FS22_beeHivePalletRack.zip", "https://cdn10.giants-software.com/modHub/storage/00230416/FS22_TajfunEGV80AHK.zip", "https://cdn10.giants-software.com/modHub/storage/00230769/FS22_HorseHelper.zip", "https://cdn10.giants-software.com/modHub/storage/00231587/FS22_realDirtColorTracks.zip", "https://cdn10.giants-software.com/modHub/storage/00233456/FS22_AutoloaderStockPackjw.zip", "https://cdn10.giants-software.com/modHub/storage/00233491/FS22_Lizard_Modular_BGA.zip", "https://cdn10.giants-software.com/modHub/storage/00234158/FS22_745C.zip", "https://cdn10.giants-software.com/modHub/storage/00234617/FS22_kvernelandIXtrackT4.zip", "https://cdn10.giants-software.com/modHub/storage/00234618/FS22_newHollandDiscbine313.zip", "https://cdn10.giants-software.com/modHub/storage/00235298/FS22_fellaGrasslandEquipment.zip", "https://cdn10.giants-software.com/modHub/storage/00235328/FS22_ExtendedBaleWrapColors.zip", "https://cdn10.giants-software.com/modHub/storage/00235670/FS22_The_Old_Stream_Farm.zip", "https://cdn10.giants-software.com/modHub/storage/00236621/FS22_Maypole_Farm.zip", "https://cdn10.giants-software.com/modHub/storage/00241186/FS22_Osada.zip", "https://cdn10.giants-software.com/modHub/storage/00244893/FS22_HomemadeRTK.zip", "https://cdn20.giants-software.com/modHub/storage/00223930/FS22_CollectStrawAtMissions.zip", "https://cdn20.giants-software.com/modHub/storage/00225090/FS22_RollandPack.zip", "https://cdn20.giants-software.com/modHub/storage/00227407/FS22_kvernelandDGll12000.zip", "https://cdn20.giants-software.com/modHub/storage/00227410/FS22_viconExtraPack.zip", "https://cdn20.giants-software.com/modHub/storage/00227996/FS22_BigBagStorage.zip", "https://cdn20.giants-software.com/modHub/storage/00229595/FS22_ChocolateMuesliFactory.zip", "https://cdn20.giants-software.com/modHub/storage/00229672/FS22_additionalFieldInfo.zip", "https://cdn20.giants-software.com/modHub/storage/00229963/FS22_rootCropStorage.zip", "https://cdn20.giants-software.com/modHub/storage/00232831/FS22_LizardLVrollers.zip", "https://cdn20.giants-software.com/modHub/storage/00233817/FS22_Dunalka.zip", "https://cdn20.giants-software.com/modHub/storage/00233975/FS22_SellPriceTrigger.zip", "https://cdn20.giants-software.com/modHub/storage/00234272/FS22_Claas_Krone_Baler_Pack_With_Lizard_R90.zip", "https://cdn20.giants-software.com/modHub/storage/00234483/FS22_WoodHarvesterMeasurement.zip", "https://cdn20.giants-software.com/modHub/storage/00234994/FS22_Trans_70.zip", "https://cdn20.giants-software.com/modHub/storage/00236597/FS22_HelperAdmin.zip", "https://cdn20.giants-software.com/modHub/storage/00236652/FS22_HelperNameHelper.zip", "https://cdn20.giants-software.com/modHub/storage/00236852/FS22_JD_HX20.zip", "https://cdn20.giants-software.com/modHub/storage/00237793/FS22_yardProductionPack.zip", "https://cdn20.giants-software.com/modHub/storage/00244364/FS22_Caffini_DriftStopperEvo.zip", "https://cdn20.giants-software.com/modHub/storage/00245260/FS22_Holmakra.zip", "https://cdn20.giants-software.com/modHub/storage/00245867/FS22_realDirtParticles.zip", "https://cdn20.giants-software.com/modHub/storage/00246012/FS22_SeedPotatoFarmVehicles.zip", "https://cdn20.giants-software.com/modHub/storage/00246051/FS22_SeedPotatoFarmBuildings.zip", "https://cdn70.giants-software.com/modHub/storage/00225272/FS22_SkidSteer_Mower.zip", "https://cdn70.giants-software.com/modHub/storage/00225280/FS22_autonomousCaseIH.zip", "https://cdn70.giants-software.com/modHub/storage/00227440/FS22_Multi_Production_Factory.zip", "https://cdn70.giants-software.com/modHub/storage/00228574/FS22_Case_IH_Traction_King_Series.zip", "https://cdn70.giants-software.com/modHub/storage/00228819/FS22_aPalletAutoLoader.zip", "https://cdn70.giants-software.com/modHub/storage/00229112/FS22_realDirtFix.zip", "https://cdn70.giants-software.com/modHub/storage/00229759/FS22_Pack_Multifruit_Container.zip", "https://cdn70.giants-software.com/modHub/storage/00230326/FS22_Lizard_FieldBin.zip", "https://cdn70.giants-software.com/modHub/storage/00232693/FS22_DangrevillePack.zip", "https://cdn70.giants-software.com/modHub/storage/00232778/FS22_moreHoneyPalletPlaceOptions.zip", "https://cdn70.giants-software.com/modHub/storage/00233108/FS22_TheFrenchPlain.zip", "https://cdn70.giants-software.com/modHub/storage/00233639/FS22_rake.zip", "https://cdn70.giants-software.com/modHub/storage/00233678/FS22_AutoPalletsManager.zip", "https://cdn70.giants-software.com/modHub/storage/00234921/FS22_BetterContracts.zip", "https://cdn70.giants-software.com/modHub/storage/00236320/FS22_JohnDeere_110_4x4.zip", "https://cdn70.giants-software.com/modHub/storage/00237080/FS22_UniversalAutoload.zip", "https://cdn70.giants-software.com/modHub/storage/00238536/FS22_REAimplements.zip", "https://cdn70.giants-software.com/modHub/storage/00238781/FS22_Leboulch_gold_k150.zip", "https://cdn70.giants-software.com/modHub/storage/00240756/FS22_salford8312.zip", "https://cdn70.giants-software.com/modHub/storage/00240757/FS22_kuhnSR314.zip", "https://cdn70.giants-software.com/modHub/storage/00246494/FS22_ManureFix.zip", "https://github.com/Courseplay/Courseplay_FS22/releases/download/7.3.1.5/FS22_Courseplay.zip", "https://github.com/Stephan-S/FS22_AutoDrive/releases/download/2.0.1.4/FS22_AutoDrive.zip"
    )
  }

  [Void] InstallFS22Mod([PSCustomObject]$ChildLogger, [String]$URI) {
    $FileName = $URI.Substring($URI.LastIndexOf("/") + 1)
    $DestPath = "$($this.FS22ModDir)/$FileName"

    if (Test-Path -Path $DestPath) {
      return
    }

    $ChildLogger.Info($(Invoke-WebRequest -Uri -OutFile $DestPath))
  }

  [Void] InstallFS22Mods() {
    $this.Logger.Info(" Downloading FS22 mods...")
    if (-not (Test-Path -Path $this.FS22ModDir)) {
      $this.Logger.Info(" FS22 mods folder is missing. Skipping mod installation.")
      return
    }

    $ChildLogger = $this.Logger.ChildLogger()
    foreach ($Mod in $this.FS22Mods) {
      $this.InstallFS22Mod($ChildLogger, $Mod)
      $ModName = Split-Path -Leaf $Mod
      $ChildLogger.Info(" $ModName FS22 mod installed")
    }
    $this.Logger.Info(" FS22 mods downloaded.")
  }
}

[FS22]::new($Logger).InstallFS22Mods()

} catch {
  $Info = $error[0].InvocationInfo
  Write-Host "Exception: $($Info.ScriptLineNumber): $($Info.Line)"
  Write-Host $error
  exit 1
}
