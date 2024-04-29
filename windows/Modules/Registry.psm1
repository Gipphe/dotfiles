#Requires -Version 7.3

Import-Module $PSScriptRoot/Stamp.psm1

$ErrorActionPreference = "Stop"

class Registry {
  [PSCustomObject]$Stamp

  Registry() {
    $this.Stamp = New-Stamp
  }

  [Void] StampEntry([String]$Stamp, [String]$Path, [String]$Entry, [String]$Type, [String]$Data) {
    $this.Stamp.Register($Stamp, {
      reg add "$Path" /v "$Entry" /t "$Type" /d $Data /f
    })
  }

  [Void] SetEntries() {
    # Use checkboxes for selecting files
    $this.StampEntry(
      "register-checkboxes",
      "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced",
      "AutoCheckSelect",
      "REG_DWORD",
      1
    )
    # Show hidden files
    $this.StampEntry(
      "register-hidden-files",
      "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced",
      "Hidden",
      "REG_DWORD",
      1
    )
    # Always show file extensions
    $this.StampEntry(
      "register-show-file-extensions",
      "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced",
      "HideFileExt",
      "REG_DWORD",
      0
    )
    # Search files and folders in the Start Menu
    $this.StampEntry(
      "register-search-file-and-folders",
      "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced",
      "Start_SearchFiles",
      "REG_DWORD",
      2
    )
    # Disable UAC for all users
    $this.StampEntry(
      "register-disable-uac",
      "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System",
      "EnableLUA",
      "REG_DWORD",
      0
    )

    # Set window colors
    # $this.StampEntry(
    #   "set-window-colors",
    #   "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent",
    #   "AccentColorMenu",
    #   "REG_DWORD",
    #   "ffb86487"
    # )
    $this.StampEntry(
      "register-window-accent-color-menu",
      "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent",
      "AccentColorMenu",
      "REG_DWORD",
      4290274439
    )
    $this.StampEntry(
      "register-window-accept-palette",
      "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent",
      "AcceptPalette",
      "REG_BINARY",
      "d4b5ff00c096fa00a882dd008764b8005b3e83003c2759002b1c40008e8cd800"
    )
    # $this.StampEntry(
    #   "set-window-accent-color",
    #   "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent",
    #   "StartColorMenu",
    #   "REG_DWORD",
    #   "ff833e5b"
    # )
    $this.StampEntry(
      "register-color-start-color-menu",
      "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent",
      "StartColorMenu",
      "REG_DWORD",
      4286791259
    )

    # Disable keyboard layout hotkeys
    $this.StampEntry(
      "register-disable-keyboard-layout-hotkey-base",
      "HKCU\Keyboard Layout/Toggle",
      "Hotkey",
      "REG_SZ",
      3
    )
    $this.StampEntry(
      "register-disable-keyboard-language-hotkey",
      "HKCU\Keyboard Layout/Toggle",
      "Language Hotkey",
      "REG_SZ",
      3
    )
    $this.StampEntry(
      "register-disable-keyboard-layout-hotkey",
      "HKCU\Keyboard Layout/Toggle",
      "Layout Hotkey",
      "REG_SZ",
      3
    )

    # Disable Taskbar Search bar
    $this.StampEntry(
      "register-disable-taskbar-search-bar",
      "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search",
      "SearchboxTaskbarMode",
      "REG_DWORD",
      0
    )
    # Disable News and Interests from Start Menu
    $this.StampEntry(
      "register-disable-news-and-interest-start-menu",
      "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds",
      "ShellFeedsTaskbarViewMode",
      "REG_DWORD",
      2
    )
    # Hide Task View button from Taskbar
    $this.StampEntry(
      "register-disable-taskbar-task-view",
      "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced",
      "ShowTaskViewButton",
      "REG_DWORD",
      0
    )
    # Use small icons in Taskbar
    $this.StampEntry(
      "register-use-small-icons-taskbar",
      "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced",
      "TaskbarSmallIcons",
      "REG_DWORD",
      1
    )
    # Don't collapse taskbar items until taskbar is full
    $this.StampEntry(
      "register-show-full-taskbar-items",
      "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced",
      "TaskbarGlomLevel",
      "REG_DWORD",
      1
    )
    # Lock taskbar
    $this.StampEntry(
      "register-lock-taskbar",
      "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced",
      "TaskbarSizeMove",
      "REG_DWORD",
      0
    )
    # TODO find a way to change the taskbar height with registry entries (or otherwise)
    # Show all icons in notification area
    $this.StampEntry(
      "register-show-all-notification-area-icons",
      "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer",
      "EnableAutoTray",
      "REG_DWORD",
      0
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
  }
}

function New-Registry {
  [Registry]::new()
}

Export-ModuleMember -Function New-Registry
