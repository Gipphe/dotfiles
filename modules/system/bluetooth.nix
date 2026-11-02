{
  den.aspects.system.bluetooth.nixos = { pkgs, ... }: {
    services.blueman.enable = true;
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      package = pkgs.bluez5-experimental;
      # Enable A2DP sinks
      settings.General.Enable = "Source,Sink,Media,Socket";
    };
  };
}
