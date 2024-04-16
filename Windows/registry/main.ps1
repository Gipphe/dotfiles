[CmdletBinding()]
Param ()

. "$Dirname\utils.ps1"
. "$Dirname\stamp.ps1"

Initialize-Stamp

Function Set-RegistryEntries
{
  [CmdletBinding()]
  Param ()

  # Use checkboxes for selecting files
  Register-Stamp "register-checkboxes" {
    Invoke-Native { reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v AutoCheckSelect /t REG_DWORD /d 1 /f } 
  }
  # Show hidden files
  Register-Stamp "register-hidden-files" {
    Invoke-Native { reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Hidden /t REG_DWORD /d 1 /f }
  }
  # Always show file extensions
  Register-Stamp "register-show-file-extensions" {
    Invoke-Native { reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideFileExt /t REG_DWORD /d 0 /f }
  }
  # Search files and folders in the Start Menu
  Register-Stamp "register-search-file-and-folders" {
    Invoke-Native { reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Start_SearchFiles /t REG_DWORD /d 2 /f }
  }
  # Disable UAC for all users
  Register-Stamp "register-disable-uac" {
    Invoke-Native { reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f }
  }

  # Set window colors
  # Invoke-Native { reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent /v AccentColorMenu /t REG_DWORD /d ffb86487 /f }
  Register-Stamp "register-window-accent-color-menu" {
    Invoke-Native { reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent /v AccentColorMenu /t REG_DWORD /d 4290274439 /f }
  }
  Register-Stamp "register-window-accept-palette" {
    Invoke-Native { reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent /v AcceptPalette /t REG_BINARY /d d4b5ff00c096fa00a882dd008764b8005b3e83003c2759002b1c40008e8cd800 /f }
  }
  # Invoke-Native { reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent /v StartColorMenu /t REG_DWORD /d ff833e5b /f }
  Register-Stamp "register-color-start-color-menu" {
    Invoke-Native { reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent /v StartColorMenu /t REG_DWORD /d 4286791259 /f }
  }

  # Disable keyboard layout hotkeys
  Register-Stamp "register-disable-keyboard-layout-hotkey-base" {
    Invoke-Native { reg add "HKCU\Keyboard Layout/Toggle" /v Hotkey /t REG_SZ /d 3 /f }
  }
  Register-Stamp "register-disable-keyboard-language-hotkey" {
    Invoke-Native { reg add "HKCU\Keyboard Layout/Toggle" /v "Language Hotkey" /t REG_SZ /d 3 /f }
  }
  Register-Stamp "register-disable-keyboard-layout-hotkey" {
    Invoke-Native { reg add "HKCU\Keyboard Layout/Toggle" /v "Layout Hotkey" /t REG_SZ /d 3 /f }
  }

  # Disable Taskbar Search bar
  Register-Stamp "register-disable-taskbar-search-bar" {
    Invoke-Native { reg add HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /v SearchboxTaskbarMode /t REG_DWORD /d 0 /f }
  }
  # Disable News and Interests from Start Menu
  Register-Stamp "register-disable-news-and-interest-start-menu" {
    Invoke-Native { reg add HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds /v ShellFeedsTaskbarViewMode /t REG_DWORD /d 2 /f }
  }
  # Hide Task View button from Taskbar
  Register-Stamp "register-disable-taskbar-task-view" {
    Invoke-Native { reg add HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowTaskViewButton /t REG_DWORD /d 0 /f }
  }
  # Use small icons in Taskbar
  Register-Stamp "register-use-small-icons-taskbar" {
    Invoke-Native { reg add HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarSmallIcons /t REG_DWORD /d 1 /f }
  }
  # Don't collapse taskbar items until taskbar is full
  Register-Stamp "register-show-full-taskbar-items" {
    Invoke-Native { reg add HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarGlomLevel /t REG_DWORD /d 1 /f }
  }
  # Lock taskbar
  Register-Stamp "register-lock-taskbar" {
    Invoke-Native { reg add HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarSizeMove /t REG_DWORD /d 0 /f }
  }
  # TODO find a way to change the taskbar height with registry entries (or otherwise)
  # Show all icons in notification area
  Register-Stamp "register-show-all-notification-area-icons" {
    Invoke-Native { reg add HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer /v EnableAutoTray /t REG_DWORD /d 0 /f }
  }

  $AutoLoginEnabled = $False
  try
  {
    $Prop = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'AutoAdminLogon'
    $Prop
    $AutoLoginEnabled = $Prop.AutoAdminLogon -eq '1'
    $AutoLoginEnabled
  } catch
  {
  }

  If (-Not $AutoLoginEnabled)
  {
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
