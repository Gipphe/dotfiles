{ pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../modules/agenix.nix
    ../modules/audio.nix
    ../modules/core.nix
    ../modules/desktop.nix
    ../modules/desktop.nix
    ../modules/hyprland.nix
    ../modules/nix.nix
    ../modules/nvidia.nix
    ../modules/user.nix
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Enable VirtualBox additions to make shared clipboard and other niceties work
  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.guest.x11 = true;

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

  # hardware.opengl = {
  #   driSupport = true;
  #   driSupport32Bit = true;
  #   extraPackages = with pkgs; [
  #     vaapiVdpau
  #     libvdpau-va-gl
  #   ];
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
