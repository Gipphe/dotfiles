{ util, inputs, lib, ... }:
util.mkToggledModule [ "machines" ] {
  name = "sodium";

  shared.gipphe = {
    username = "gipphe";
    homeDirectory = "/home/gipphe";
    hostName = "sodium";
    profiles = {
      nixos = {
        audio.enable = true;
        bluetooth.enable = true;
        boot-efi.enable = true;
        devices.enable = true;
        system.enable = true;
      };
      ai.enable = true;
      audio.enable = true;
      cli.enable = true;
      core.enable = true;
      desktop-hyprland.enable = true;
      # desktop-normal.enable = true;
      desktop.enable = true;
      fonts.enable = true;
      gaming.enable = true;
      gc.enable = true;
      networkmanager.enable = true;
      rice.enable = true;
      secrets.enable = true;
      sync.enable = true;
      systemd.enable = true;
      windows-setup.enable = true;
    };
    programs.idea-community.enable = true;
  };

  system-nixos = {
    # imports = with inputs.nixos-hardware.nixosModules; [
    #   dell-precision-
    # ];

    boot.initrd.luks.devices."luks-03a05c7c-fec2-435a-a17c-40693494c8ea".device = "/dev/disk/by-uuid/03a05c7c-fec2-435a-a17c-40693494c8ea";

    system.stateVersion = lib.mkForce "25.05";
  };
}
