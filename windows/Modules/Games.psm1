#Requires -Version 5.1

$ErrorActionPreference = "Stop"

class Games {
  [String]$FS22ModDir
  [String[]]$FS22Mods

  Games() {
    if ($null -eq $Env:HOME) {
      $Env:HOME = $Env:USERPROFILE
    }
    $HOME = $Env:HOME
    $this.FS22ModDir = "$HOME/Documents/My Games/FarmingSimulator2022/mods"

    $this.FS22Mods = @(
      "https://cdn10.giants-software.com/modHub/storage/00225543/FS22_additionalCurrencies.zip",
      "https://cdn10.giants-software.com/modHub/storage/00226183/FS22_DeutzSeries7_8.zip",
      "https://cdn10.giants-software.com/modHub/storage/00227409/FS22_viconAndex1304Pro.zip",
      "https://cdn10.giants-software.com/modHub/storage/00228105/FS22_airHoseConnectSound.zip",
      "https://cdn10.giants-software.com/modHub/storage/00228206/FS22_LandBakery.zip",
      "https://cdn10.giants-software.com/modHub/storage/00228541/FS22_poettingerNovaDiscPack.zip",
      "https://cdn10.giants-software.com/modHub/storage/00228604/FS22_realDirtColor.zip",
      "https://cdn10.giants-software.com/modHub/storage/00228656/FS22_TLX2020_Series.zip",
      "https://cdn10.giants-software.com/modHub/storage/00228771/FS22_Profihopper.zip",
      "https://cdn10.giants-software.com/modHub/storage/00229254/FS22_claasDiscoPack.zip",
      "https://cdn10.giants-software.com/modHub/storage/00230002/FS22_beeHivePalletRack.zip",
      "https://cdn10.giants-software.com/modHub/storage/00230416/FS22_TajfunEGV80AHK.zip",
      "https://cdn10.giants-software.com/modHub/storage/00230769/FS22_HorseHelper.zip",
      "https://cdn10.giants-software.com/modHub/storage/00231587/FS22_realDirtColorTracks.zip",
      "https://cdn10.giants-software.com/modHub/storage/00233456/FS22_AutoloaderStockPackjw.zip",
      "https://cdn10.giants-software.com/modHub/storage/00233491/FS22_Lizard_Modular_BGA.zip",
      "https://cdn10.giants-software.com/modHub/storage/00234158/FS22_745C.zip",
      "https://cdn10.giants-software.com/modHub/storage/00234617/FS22_kvernelandIXtrackT4.zip",
      "https://cdn10.giants-software.com/modHub/storage/00234618/FS22_newHollandDiscbine313.zip",
      "https://cdn10.giants-software.com/modHub/storage/00235298/FS22_fellaGrasslandEquipment.zip",
      "https://cdn10.giants-software.com/modHub/storage/00235328/FS22_ExtendedBaleWrapColors.zip",
      "https://cdn10.giants-software.com/modHub/storage/00235670/FS22_The_Old_Stream_Farm.zip",
      "https://cdn10.giants-software.com/modHub/storage/00236621/FS22_Maypole_Farm.zip",
      "https://cdn10.giants-software.com/modHub/storage/00241186/FS22_Osada.zip",
      "https://cdn10.giants-software.com/modHub/storage/00244893/FS22_HomemadeRTK.zip",
      "https://cdn20.giants-software.com/modHub/storage/00223930/FS22_CollectStrawAtMissions.zip",
      "https://cdn20.giants-software.com/modHub/storage/00225090/FS22_RollandPack.zip",
      "https://cdn20.giants-software.com/modHub/storage/00227407/FS22_kvernelandDGll12000.zip",
      "https://cdn20.giants-software.com/modHub/storage/00227410/FS22_viconExtraPack.zip",
      "https://cdn20.giants-software.com/modHub/storage/00227996/FS22_BigBagStorage.zip",
      "https://cdn20.giants-software.com/modHub/storage/00229595/FS22_ChocolateMuesliFactory.zip",
      "https://cdn20.giants-software.com/modHub/storage/00229672/FS22_additionalFieldInfo.zip",
      "https://cdn20.giants-software.com/modHub/storage/00229963/FS22_rootCropStorage.zip",
      "https://cdn20.giants-software.com/modHub/storage/00232831/FS22_LizardLVrollers.zip",
      "https://cdn20.giants-software.com/modHub/storage/00233817/FS22_Dunalka.zip",
      "https://cdn20.giants-software.com/modHub/storage/00233975/FS22_SellPriceTrigger.zip",
      "https://cdn20.giants-software.com/modHub/storage/00234272/FS22_Claas_Krone_Baler_Pack_With_Lizard_R90.zip",
      "https://cdn20.giants-software.com/modHub/storage/00234483/FS22_WoodHarvesterMeasurement.zip",
      "https://cdn20.giants-software.com/modHub/storage/00234994/FS22_Trans_70.zip",
      "https://cdn20.giants-software.com/modHub/storage/00236597/FS22_HelperAdmin.zip",
      "https://cdn20.giants-software.com/modHub/storage/00236652/FS22_HelperNameHelper.zip",
      "https://cdn20.giants-software.com/modHub/storage/00236852/FS22_JD_HX20.zip",
      "https://cdn20.giants-software.com/modHub/storage/00237793/FS22_yardProductionPack.zip"
      "https://cdn20.giants-software.com/modHub/storage/00244364/FS22_Caffini_DriftStopperEvo.zip",
      "https://cdn20.giants-software.com/modHub/storage/00245260/FS22_Holmakra.zip",
      "https://cdn20.giants-software.com/modHub/storage/00245867/FS22_realDirtParticles.zip",
      "https://cdn20.giants-software.com/modHub/storage/00246012/FS22_SeedPotatoFarmVehicles.zip",
      "https://cdn20.giants-software.com/modHub/storage/00246051/FS22_SeedPotatoFarmBuildings.zip",
      "https://cdn70.giants-software.com/modHub/storage/00225272/FS22_SkidSteer_Mower.zip",
      "https://cdn70.giants-software.com/modHub/storage/00225280/FS22_autonomousCaseIH.zip",
      "https://cdn70.giants-software.com/modHub/storage/00227440/FS22_Multi_Production_Factory.zip",
      "https://cdn70.giants-software.com/modHub/storage/00228574/FS22_Case_IH_Traction_King_Series.zip",
      "https://cdn70.giants-software.com/modHub/storage/00228819/FS22_aPalletAutoLoader.zip",
      "https://cdn70.giants-software.com/modHub/storage/00229112/FS22_realDirtFix.zip",
      "https://cdn70.giants-software.com/modHub/storage/00229759/FS22_Pack_Multifruit_Container.zip",
      "https://cdn70.giants-software.com/modHub/storage/00230326/FS22_Lizard_FieldBin.zip",
      "https://cdn70.giants-software.com/modHub/storage/00232693/FS22_DangrevillePack.zip",
      "https://cdn70.giants-software.com/modHub/storage/00232778/FS22_moreHoneyPalletPlaceOptions.zip",
      "https://cdn70.giants-software.com/modHub/storage/00233108/FS22_TheFrenchPlain.zip",
      "https://cdn70.giants-software.com/modHub/storage/00233639/FS22_rake.zip",
      "https://cdn70.giants-software.com/modHub/storage/00233678/FS22_AutoPalletsManager.zip",
      "https://cdn70.giants-software.com/modHub/storage/00234921/FS22_BetterContracts.zip",
      "https://cdn70.giants-software.com/modHub/storage/00236320/FS22_JohnDeere_110_4x4.zip",
      "https://cdn70.giants-software.com/modHub/storage/00237080/FS22_UniversalAutoload.zip",
      "https://cdn70.giants-software.com/modHub/storage/00238536/FS22_REAimplements.zip",
      "https://cdn70.giants-software.com/modHub/storage/00238781/FS22_Leboulch_gold_k150.zip",
      "https://cdn70.giants-software.com/modHub/storage/00240756/FS22_salford8312.zip",
      "https://cdn70.giants-software.com/modHub/storage/00240757/FS22_kuhnSR314.zip",
      "https://cdn70.giants-software.com/modHub/storage/00246494/FS22_ManureFix.zip",
      "https://github.com/Courseplay/Courseplay_FS22/releases/download/7.3.1.5/FS22_Courseplay.zip",
      "https://github.com/Stephan-S/FS22_AutoDrive/releases/download/2.0.1.4/FS22_AutoDrive.zip"
    )
  }

  [Void] InstallFS22Mod([String]$URI) {
    $FileName = $URI.Substring($URI.LastIndexOf("/") + 1)
    $DestPath = "$($this.FS22ModDir)/$FileName"

    if (Test-Path -Path $DestPath) {
      return
    }

    Invoke-WebRequest -Uri -OutFile $DestPath
  }

  [Void] InstallFS22Mods() {
    if (-not (Test-Path -Path $this.FS22ModDir)) {
      Write-Information "FS22 mods folder is missing. Skipping mod installation."
      return
    }

    foreach ($Mod in $this.FS22Mods) {
      $this.InstallFS22Mod($Mod)
    }
  }
}

function New-Games {
  [Games]::new()
}

Export-ModuleMember -Function New-Games
