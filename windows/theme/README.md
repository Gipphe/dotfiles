# Themeing for Windows

## Start menu button

[Catppuccin-like icon] for use with Start10.

`startppuccin.pdn`: source file in Paint.NET format.

## Windows Explorer theme

1. Create a system restore point, for good measure.
1. Take ownership of `C:\Windows\System32\uxinit.dll` and `C:\Windows\System32\themeui.dll`. Easy to do with [this tool].
1. Install [UltraUXThemePatcher].
1. Reboot.
1. Restart UltraUXThemePatcher to verify that the machine is patched.
1. Use [this theme]. Copy the theme contents to `C:\Windows\Resources\theme`.
1. Select the theme under `Settings > Personalization > Theme`.

## OldNewExplorer

1. [Download][download-one].
1. Start it.
1. Click "install".
1. Customize.
1. Restart Windows Explorer.

[this theme]: https://www.deviantart.com/niivu/art/Catppuccin-for-Windows-10-908988670
[this tool]: https://codeberg.org/Gipphe/dotfiles/src/branch/main/windows/theme/take-ownership/Add%20Take%20Ownership%20to%20Context%20menu.reg
[UltraUXThemePatcher]: https://mhoefs.eu/software_uxtheme.php?ref=syssel&lang=en
[download-one]: https://msfn.org/board/topic/170375-oldnewexplorer-119/
[Catppuccin-like icon]: https://codeberg.org/Gipphe/dotfiles/src/branch/main/windows/theme/startppuccin/
