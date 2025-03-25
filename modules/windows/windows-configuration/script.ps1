#Requires -Version 5.1
[CmdletBinding()]
param ()


$Check = ""
$Hg = ""
$Cross = "✗"


###########
# Utilities
###########

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

function Resolve-PathNice {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [String]$Path
  )

  return $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
}


try {
  $Profile = ConvertFrom-Json $(Get-Contents "$PSScriptRoot\profiles\$($Env:COMPUTERNAME.ToLower()).json"))

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


  function Config {
    $CfgDir = "$PSSCriptRoot/configs"
    $Logger.Info("$Hg Copying config files...")
    $ChildLogger = $Logger.ChildLogger()
    $baseUrl = $Env:USERPROFILE
    $Items = Get-ChildItem -File -Recurse $CfgDir | Resolve-Path -Relative -RelativeBasePath $CfgDir

    $Items | ForEach-Object {
      $From = Resolve-PathNice "$CfgDir/$_"
      $To = Resolve-PathNice "$baseUrl/$_"

      # Ensure parent dir exists
      $ToDir = Split-Path -Parent $To
      if (-not (Test-Path -PathType Container $ToDir)) {
        New-Item -Force -ItemType Directory $ToDir
      }

      # Clean out existing destination if it is a directory. Otherwise, we'll
      # end up copying _into_ the existing directory.
      if (Test-Path $To) {
        Move-Item $To "$To.backup"
        $ChildLogger.Info("$Check backed up existing $To item")
      }

      Copy-Item -Force -Recurse -Path $From -Destination $To
      $FileName = Split-Path -Leaf $From
      $ChildLogger.Info("$Check $_ copied")
    }

    $Logger.Info("$Check Config files copied.")
  }
  Config


  function Environment {
    $Logger.Info("$Hg Setting env vars...")
    $ChildLogger = $Logger.ChildLogger()
    $EnvVars = $Profile.environment.variables
    $EnvVars.GetEnumerator() | ForEach-Object {
      $key = $_.Key
      $enabled = $true
      $val = $_.Value
      if (-not isString($val)) {
        $enabled = $val.enable
        $val = $val.value
      }
      if ($enabled) {
        [Environment]::SetEnvironmentVariable($key, $val, 'User')
      }
      $ChildLogger.Info("$Check $key env var set")
    }
    $Logger.Info("$Check Env vars set.")
  }
  Environment


  function Programs {
    $Logger.Info("$Hg Installing manually installed programs...")

    $ChildLogger = $Logger.ChildLogger()

    $Programs = $Profile.programs

    $Programs.GetEnumerator() | ForEach-Object {
      $Name = $_.Key
      $enabled = $_.Value.enable
      $URI = $_.Value.url
      $StampName = $_.Value.stampName
      if ($enabled) {
        $Stamp.Register($StampName, {
          Install-FromWeb $Name $URI $ChildLogger
        })
      }
    }

    $Logger.Info("$Check Programs installed.")
  }
  Programs


  function InstallChocolatey {
    try {
      Get-Command "choco" -ErrorAction Stop | Out-Null
    } catch {
      Set-ExecutionPolicy Bypass -Scope Process -Force
      [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
      Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
  }

  function InstallChocoApps {
    $Logger.Info("$Hg Installing Chocolatey programs...")
    $ChocoArgs = @('-y')
    $Installed = Invoke-Native { choco list --id-only }

    $ChocoApps = $Profile.chocolatey.programs

    $ChildLogger = $Logger.ChildLogger()

    $ChocoApps | ForEach-Object {
      $PackageName = $_
      $PackageArgs = $null
      if ($PackageName -isnot [String]) {
        $PackageName = $_.name
        $PackageArgs = $_.args
      }
      if ($Installed.Contains($PackageName)) {
        $ChildLogger.Info("$Check $PackageName is already installed")
        return
      }

      $params = ""
      if ($null -ne $PackageArgs) {
        $params = $PackageArgs
      }

      $ChildLogger.Info($(Invoke-Native { choco install @ChocoArgs $PackageName $params }))
      $ChildLogger.Info("$Check $PackageName installed.")
    }

    $Logger.Info("$Check Chocolatey programs installed.")
  }
  InstallChocolatey
  InstallChocoApps


  function InstallScoop {
    try {
      Get-Command "scoop" -ErrorAction Stop
    } catch {
      Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
      Invoke-RestMethod -Uri "https://get.scoop.sh" | Invoke-Expression
    }
  }
  function InstallScoopApps {
    $Logger.Info("$Hg Installing scoop programs...")
    $ChildLogger = $Logger.ChildLogger()
    $InstalledBuckets = Invoke-Native { scoop bucket list 6>$Null } | ForEach-Object { $_.Name }
    $InstalledApps = Invoke-Native { scoop list 6>$Null } | ForEach-Object { $_.Name }

    $Scoop = $Profile.scoop
    $RequiredBuckets = $Scoop.buckets
    $RequiredApps = $Scoop.programs

    $RequiredBuckets | ForEach-Object {
      $BucketName = $_

      if (-not ($InstalledBuckets.Contains($BucketName))) {
        $ChildLogger.Info($(Invoke-Native { scoop bucket add $BucketName }))
      }

      $ChildLogger.Info("$Check $BucketName bucket installed.")
    }

    $RequiredApps | ForEach-Object {
      $PackageName = $_

      if (-not ($InstalledApps.Contains($PackageName))) {
        $ChildLogger.Info($(Invoke-Native { scoop install $PackageName }))
      }

      $ChildLogger.Info("$Check $PackageName package installed.")
    }

    $this.Logger.Info("$Check Scoop programs installed.")
  }
  InstallScoop
  InstallScoopApps


  function SetRegistryEntries {
    $ChildLogger = $Logger.ChildLogger()

    function StampifyPath {
      [CmdletBinding()]
      param (
        [Parameter(Mandatory)]
        [String]$Path,

        [Parameter(Mandatory)]
        [String]$Name
      )
      $pp = $Path.Replace('/', '-').Replace('\', '-')
      $pn = $Name.Replace('/', '-').Replace('\', '-')
      return "$pp-$pn"
    }

    function StampEntry {
      [CmdletBinding()]
      param (
        [String]$Stamp,
        [String]$Path,
        [String]$Entry,
        [String]$Type,
        [String]$Data
      )

      $Stamp.Register($Stamp, {
        $ChildLogger.Info("Setting $Path\$Entry")
        reg add "$Path" /v "$Entry" /t "$Type" /d $Data /f
      })
    }

    $Logger.Info("$Hg Setting registry entries...")

    $Registry = $Profile.registry

    foreach ($x in $Registry.entries.GetEnumerator()) {
      $StampEntry(
        $ChildLogger,
        $(StampifyPath -Path $x.path -Name $.entry),
        $x.path,
        $x.entry,
        $x.type,
        "$($x.data)"
      )
    }

    if ($Registry.enableAutoLogin) {
      $AutoLoginEnabled = $false
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
    }

    $Logger.Info("$Check Registry entries set.")
  }
  SetRegistryEntries


  function InstallSD() {
    $Logger.Info("$Hg Setting up SD...")
    $ChildLogger = $Logger.ChildLogger()
    $SDDir = "$PSScriptRoot\_temp"
    Remove-Item -Force -Recurse -ErrorAction 'SilentlyContinue' -Path $SDDir
    try {
      Invoke-Native { git clone "https://gitlab.org/Gipphe/sd.git" "$SDDir" }
      if (-not (Test-Path -PathType Container "$SDDir")) {
        $ChildLogger.Info("$Cross $SDDir does not exist, even though we _just_ cloned into it.")
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
      $ChildLogger.Info("$Check SD repo downloaded and initialized.")
    } catch {
      $ChildLogger.Info("$Cross Failed to setup SD")
      $ChildLogger.Info($error[0])
    } finally {
      Remove-Item -Force -Recurse -ErrorAction 'SilentlyContinue' -Path $SDDir
    }
    $Logger.Info("$Check SD set up.")
  }
  InstallSD


  function InstallWSL {
    $Logger.Info("$Hg Installing and setting up WSL...")
    $ChildLogger = $Logger.ChildLogger()

    $ChildLogger.Info("$Hg Install WSL")
    $Stamp.Register("install-wsl", {
      Invoke-Native { wsl --install }
    })
    $ChildLogger.Info("$Check WSL installed")

    $ChildLogger.Info("$Hg Install nixos-wsl image")
    $Stamp.Register("install-nixos-wsl", {
      Invoke-WebRequest `
        -Uri "https://github.com/nix-community/NixOS-WSL/releases/download/2311.5.3/nixos-wsl.tar.gz" `
        -OutFile "$HOME\Downloads\nixos-wsl.tar.gz"
      Invoke-Native { wsl --import "NixOS" "$HOME\NixOS\" "$HOME\Downloads\nixos-wsl.tar.gz" }
      Invoke-Native { wsl --set-default "NixOS" }
    })
    $ChildLogger.Info("$Check nixos-wsl installed")

    $ChildLogger.Info("$Hg Configure nixos-wsl")
    $Stamp.Register("configure-nixos", {
      Invoke-Native {
        wsl -d "NixOS" -- `
          ! test -s '$HOME/projects/dotfiles' `
          '&&' nix-shell -p git --run '"git clone https://codeberg.org/Gipphe/dotfiles.git"' '"$HOME/projects/dotfiles"' `
          '&&' cd '$HOME/projects/dotfiles' `
          '&&' nixos-rebuild --extra-experimental-features 'flakes nix-command' switch --flake '"$(pwd)#argon"'
      }
    })
    $ChildLogger.Info("$Check nixos-wsl configured")
    $Logger.Info("$Check WSL installed and set up.")
  }
  InstallWSL

} catch {
  $Info = $error[0].InvocationInfo
  Write-Host "Exception: $($Info.ScriptLineNumber): $($Info.Line)"
  Write-Host $error
  exit 1
}
