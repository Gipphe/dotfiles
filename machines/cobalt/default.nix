{ util, inputs, ... }:
util.mkToggledModule [ "machines" ] {
  name = "cobalt";

  shared.gipphe = {
    username = "gipphe";
    homeDirectory = "/home/gipphe";
    hostName = "cobalt";
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

  system-nixos.imports = with inputs.nixos-hardware.nixosModules; [
    common-cpu-intel
    common-gpu-amd
    common-pc-laptop
    common-pc-laptop-ssd
  ];
}
