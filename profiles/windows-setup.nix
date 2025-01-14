{ util, config, ... }:
util.mkProfile "windows-setup" {
  gipphe = {
    programs.floorp.windows = true;
    windows = {
      enable = true;
      destination = "${config.gipphe.homeDirectory}/projects/dotfiles/windows";
      chocolatey = {
        enable = true;
        programs = [
          "1password"
          "7zip"
          "barrier"
          "cursoride"
          "discord"
          "docker-desktop"
          "dotnet-8.0-sdk"
          "dust"
          "epicgameslauncher"
          "filen"
          "filezilla"
          "firacodenf"
          "floorp"
          "fzf"
          "gdlauncher"
          "geforce-experience"
          "git"
          "godot-mono"
          "greenshot"
          "humble-app"
          "irfanview"
          "irfanview-languages"
          "irfanviewplugins"
          "jetbrains-rider"
          "k-litecodecpack-standard"
          "lghub"
          "libresprite"
          "logseq"
          "microsoft-windows-terminal"
          "msiafterburner"
          "notion"
          "nvidia-broadcast"
          "openssh"
          "paint.net"
          "powershell-core"
          "powertoys"
          "python310"
          "python312"
          "qbittorrent"
          "restic"
          "rsync"
          "signal"
          "slack"
          "spotify"
          "starship"
          "steam"
          "sumatrapdf"
          "sunshine"
          "teamviewer"
          "vcredist-all"
          "voicemeeter"
          "wezterm"
          "windhawk"
          "windirstat"
          "xnviewmp"
          "zoxide"
          {
            name = "opera-gx";
            args = "--params='\"/NoDesktopShortcut /NoTaskbarShortcut\"'";
          }
        ];
      };
      scoop = {
        enable = true;
        buckets = [ "extras" ];
        programs = [
          "direnv"
          "ffmpeg"
          "neovide"
          "neovim"
          "stash"
        ];
      };
      home = {
        enable = true;
        file = {
          ".vimrc".source = ../modules/windows/config/.vimrc;
          ".wslconfig".source = ../modules/windows/config/.wslconfig;
          "Documents/PowerShell/Microsoft.PowerShell_profile.ps1".source =
            ../modules/windows/config/PSProfile.ps1;
          "AppData/Local/nvim/init.vim".source = ../modules/windows/config/nvim/init.vim;
        };
        download = {
          ".local/bin/filen.exe" =
            "https://github.com/FilenCloudDienste/filen-cli/releases/download/v0.0.24/filen-cli-v0.0.24-win-x64.exe";
        };
      };
      environment = {
        enable = true;
        variables = { };
      };
      games.fs22 = {
        enable = true;
        modUrls = [
          "https://cdn10.giants-software.com/modHub/storage/00225543/FS22_additionalCurrencies.zip"
          "https://cdn10.giants-software.com/modHub/storage/00226183/FS22_DeutzSeries7_8.zip"
          "https://cdn10.giants-software.com/modHub/storage/00227409/FS22_viconAndex1304Pro.zip"
          "https://cdn10.giants-software.com/modHub/storage/00228105/FS22_airHoseConnectSound.zip"
          "https://cdn10.giants-software.com/modHub/storage/00228206/FS22_LandBakery.zip"
          "https://cdn10.giants-software.com/modHub/storage/00228541/FS22_poettingerNovaDiscPack.zip"
          "https://cdn10.giants-software.com/modHub/storage/00228604/FS22_realDirtColor.zip"
          "https://cdn10.giants-software.com/modHub/storage/00228656/FS22_TLX2020_Series.zip"
          "https://cdn10.giants-software.com/modHub/storage/00228771/FS22_Profihopper.zip"
          "https://cdn10.giants-software.com/modHub/storage/00229254/FS22_claasDiscoPack.zip"
          "https://cdn10.giants-software.com/modHub/storage/00230002/FS22_beeHivePalletRack.zip"
          "https://cdn10.giants-software.com/modHub/storage/00230416/FS22_TajfunEGV80AHK.zip"
          "https://cdn10.giants-software.com/modHub/storage/00230769/FS22_HorseHelper.zip"
          "https://cdn10.giants-software.com/modHub/storage/00231587/FS22_realDirtColorTracks.zip"
          "https://cdn10.giants-software.com/modHub/storage/00233456/FS22_AutoloaderStockPackjw.zip"
          "https://cdn10.giants-software.com/modHub/storage/00233491/FS22_Lizard_Modular_BGA.zip"
          "https://cdn10.giants-software.com/modHub/storage/00234158/FS22_745C.zip"
          "https://cdn10.giants-software.com/modHub/storage/00234617/FS22_kvernelandIXtrackT4.zip"
          "https://cdn10.giants-software.com/modHub/storage/00234618/FS22_newHollandDiscbine313.zip"
          "https://cdn10.giants-software.com/modHub/storage/00235298/FS22_fellaGrasslandEquipment.zip"
          "https://cdn10.giants-software.com/modHub/storage/00235328/FS22_ExtendedBaleWrapColors.zip"
          "https://cdn10.giants-software.com/modHub/storage/00235670/FS22_The_Old_Stream_Farm.zip"
          "https://cdn10.giants-software.com/modHub/storage/00236621/FS22_Maypole_Farm.zip"
          "https://cdn10.giants-software.com/modHub/storage/00241186/FS22_Osada.zip"
          "https://cdn10.giants-software.com/modHub/storage/00244893/FS22_HomemadeRTK.zip"
          "https://cdn20.giants-software.com/modHub/storage/00223930/FS22_CollectStrawAtMissions.zip"
          "https://cdn20.giants-software.com/modHub/storage/00225090/FS22_RollandPack.zip"
          "https://cdn20.giants-software.com/modHub/storage/00227407/FS22_kvernelandDGll12000.zip"
          "https://cdn20.giants-software.com/modHub/storage/00227410/FS22_viconExtraPack.zip"
          "https://cdn20.giants-software.com/modHub/storage/00227996/FS22_BigBagStorage.zip"
          "https://cdn20.giants-software.com/modHub/storage/00229595/FS22_ChocolateMuesliFactory.zip"
          "https://cdn20.giants-software.com/modHub/storage/00229672/FS22_additionalFieldInfo.zip"
          "https://cdn20.giants-software.com/modHub/storage/00229963/FS22_rootCropStorage.zip"
          "https://cdn20.giants-software.com/modHub/storage/00232831/FS22_LizardLVrollers.zip"
          "https://cdn20.giants-software.com/modHub/storage/00233817/FS22_Dunalka.zip"
          "https://cdn20.giants-software.com/modHub/storage/00233975/FS22_SellPriceTrigger.zip"
          "https://cdn20.giants-software.com/modHub/storage/00234272/FS22_Claas_Krone_Baler_Pack_With_Lizard_R90.zip"
          "https://cdn20.giants-software.com/modHub/storage/00234483/FS22_WoodHarvesterMeasurement.zip"
          "https://cdn20.giants-software.com/modHub/storage/00234994/FS22_Trans_70.zip"
          "https://cdn20.giants-software.com/modHub/storage/00236597/FS22_HelperAdmin.zip"
          "https://cdn20.giants-software.com/modHub/storage/00236652/FS22_HelperNameHelper.zip"
          "https://cdn20.giants-software.com/modHub/storage/00236852/FS22_JD_HX20.zip"
          "https://cdn20.giants-software.com/modHub/storage/00237793/FS22_yardProductionPack.zip"
          "https://cdn20.giants-software.com/modHub/storage/00244364/FS22_Caffini_DriftStopperEvo.zip"
          "https://cdn20.giants-software.com/modHub/storage/00245260/FS22_Holmakra.zip"
          "https://cdn20.giants-software.com/modHub/storage/00245867/FS22_realDirtParticles.zip"
          "https://cdn20.giants-software.com/modHub/storage/00246012/FS22_SeedPotatoFarmVehicles.zip"
          "https://cdn20.giants-software.com/modHub/storage/00246051/FS22_SeedPotatoFarmBuildings.zip"
          "https://cdn70.giants-software.com/modHub/storage/00225272/FS22_SkidSteer_Mower.zip"
          "https://cdn70.giants-software.com/modHub/storage/00225280/FS22_autonomousCaseIH.zip"
          "https://cdn70.giants-software.com/modHub/storage/00227440/FS22_Multi_Production_Factory.zip"
          "https://cdn70.giants-software.com/modHub/storage/00228574/FS22_Case_IH_Traction_King_Series.zip"
          "https://cdn70.giants-software.com/modHub/storage/00228819/FS22_aPalletAutoLoader.zip"
          "https://cdn70.giants-software.com/modHub/storage/00229112/FS22_realDirtFix.zip"
          "https://cdn70.giants-software.com/modHub/storage/00229759/FS22_Pack_Multifruit_Container.zip"
          "https://cdn70.giants-software.com/modHub/storage/00230326/FS22_Lizard_FieldBin.zip"
          "https://cdn70.giants-software.com/modHub/storage/00232693/FS22_DangrevillePack.zip"
          "https://cdn70.giants-software.com/modHub/storage/00232778/FS22_moreHoneyPalletPlaceOptions.zip"
          "https://cdn70.giants-software.com/modHub/storage/00233108/FS22_TheFrenchPlain.zip"
          "https://cdn70.giants-software.com/modHub/storage/00233639/FS22_rake.zip"
          "https://cdn70.giants-software.com/modHub/storage/00233678/FS22_AutoPalletsManager.zip"
          "https://cdn70.giants-software.com/modHub/storage/00234921/FS22_BetterContracts.zip"
          "https://cdn70.giants-software.com/modHub/storage/00236320/FS22_JohnDeere_110_4x4.zip"
          "https://cdn70.giants-software.com/modHub/storage/00237080/FS22_UniversalAutoload.zip"
          "https://cdn70.giants-software.com/modHub/storage/00238536/FS22_REAimplements.zip"
          "https://cdn70.giants-software.com/modHub/storage/00238781/FS22_Leboulch_gold_k150.zip"
          "https://cdn70.giants-software.com/modHub/storage/00240756/FS22_salford8312.zip"
          "https://cdn70.giants-software.com/modHub/storage/00240757/FS22_kuhnSR314.zip"
          "https://cdn70.giants-software.com/modHub/storage/00246494/FS22_ManureFix.zip"
          "https://github.com/Courseplay/Courseplay_FS22/releases/download/7.3.1.5/FS22_Courseplay.zip"
          "https://github.com/Stephan-S/FS22_AutoDrive/releases/download/2.0.1.4/FS22_AutoDrive.zip"
        ];
      };
      programs = {
        enable = true;
        manual = {
          "LDPlayer" = {
            stampName = "install-ldplayer";
            url = "https://ldcdn.ldmnq.com/download/ldad/LDPlayer9.exe?n=LDPlayer9_ens_1001_ld.exe";
          };
          "VisiPics" = {
            stampName = "install-visipics";
            url = "https://altushost-swe.dl.sourceforge.net/project/visipics/VisiPics-1-31.exe";
          };
          "Hurl" = {
            stampName = "install-hurl";
            url = "https://github.com/U-C-S/Hurl/releases/download/v0.9.0/Hurl_Installer.exe";
          };
          # Required by Hurl
          "Windows App SDK" = {
            stampName = "install-windows-app-sdk";
            url = "https://aka.ms/windowsappsdk/1.5/1.5.241001000/windowsappruntimeinstall-x64.exe";
          };
        };
      };
      registry = {
        enable = true;
        enableAutoLogin = true;
        entries = [
          {
            description = "Use checkboxes for selecting files";
            path = "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
            entry = "AutoCheckSelect";
            type = "REG_DWORD";
            data = 1;
          }
          {
            description = "Show hidden files";
            path = "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
            entry = "Hidden";
            type = "REG_DWORD";
            data = 1;
          }
          {
            description = "Always show file extensions";
            path = "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
            entry = "HideFileExt";
            type = "REG_DWORD";
            data = 0;
          }
          {
            description = "Search files and folders in the Start Menu";
            path = "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
            entry = "Start_SearchFiles";
            type = "REG_DWORD";
            data = 2;
          }
          {
            description = "Disable UAC for all users";
            path = "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System";
            entry = "EnableLUA";
            type = "REG_DWORD";
            data = 0;
          }
          {
            description = "";
            path = "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent";
            entry = "AccentColorMenu";
            type = "REG_DWORD";
            data = 4290274439;
          }
          {
            description = "";
            path = "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent";
            entry = "AcceptPalette";
            type = "REG_BINARY";
            data = "d4b5ff00c096fa00a882dd008764b8005b3e83003c2759002b1c40008e8cd800";
          }
          {
            description = "";
            path = "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent";
            entry = "StartColorMenu";
            type = "REG_DWORD";
            data = 4286791259;
          }
          {
            description = "Disable keyboard layout hotkeys";
            path = "HKCU\Keyboard Layout/Toggle";
            entry = "Hotkey";
            type = "REG_SZ";
            data = 3;
          }
          {
            description = "";
            path = "HKCU\Keyboard Layout/Toggle";
            entry = "Language Hotkey";
            type = "REG_SZ";
            data = 3;
          }
          {
            description = "";
            path = "HKCU\Keyboard Layout/Toggle";
            entry = "Layout Hotkey";
            type = "REG_SZ";
            data = 3;
          }
          #
          {
            description = "Disable Taskbar Search bar";
            path = "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search";
            entry = "SearchboxTaskbarMode";
            type = "REG_DWORD";
            data = 0;
          }
          {
            description = "Disable News and Interests from Start Menu";
            path = "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds";
            entry = "ShellFeedsTaskbarViewMode";
            type = "REG_DWORD";
            data = 2;
          }
          {
            description = "Hide Task View button from Taskbar";
            path = "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
            entry = "ShowTaskViewButton";
            type = "REG_DWORD";
            data = 0;
          }
          {
            description = "Use small icons in Taskbar";
            path = "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
            entry = "TaskbarSmallIcons";
            type = "REG_DWORD";
            data = 1;
          }
          {
            description = "Don't collapse taskbar items until taskbar is full";
            path = "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
            entry = "TaskbarGlomLevel";
            type = "REG_DWORD";
            data = 1;
          }
          {
            description = "Lock taskbar";
            path = "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
            entry = "TaskbarSizeMove";
            type = "REG_DWORD";
            data = 0;
          }
          # TODO find a way to change the taskbar height with registry entries (or otherwise)
          {
            description = "Show all icons in notification area";
            path = "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer";
            entry = "EnableAutoTray";
            type = "REG_DWORD";
            data = 0;
          }
          {
            description = "Set window colors";
            path = "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent";
            entry = "AccentColorMenu";
            type = "REG_DWORD";
            data = "ffb86487";
          }
          {
            description = "";
            path = "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent";
            entry = "StartColorMenu";
            type = "REG_DWORD";
            data = "ff833e5b";
          }
        ];
      };
      sd.enable = true;
      wsl.enable = true;
    };
  };
}
