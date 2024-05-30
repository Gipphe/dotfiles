{
  services.xserver = {
    # Attempt to set the screen resolution
    virtualScreen = {
      x = 1920;
      y = 940;
    };

    # Add custom screen resolution that works nicely in VirtualBox
    monitorSection = ''
      Modeline "1920x940_60.00"  149.45  1920 2032 2240 2560  940 941 944 973  -HSync +Vsync  
    '';
    deviceSection = ''
      Option "ModeValidation"
    '';
  };
}
