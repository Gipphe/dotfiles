{ pkgs, lib, ... }:
{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
  ];

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.guest.x11 = true;

  services.xserver = {
    virtualScreen = { x = 1920; y = 940; };
    monitorSection = ''
      Modeline "1920x940_60.00"  149.45  1920 2032 2240 2560  940 941 944 973  -HSync +Vsync  
    '';
    deviceSection = ''
      Option "ModeValidation"
    '';
  };

  services.openssh.enable = true;

  # hardware.opengl = {
  #   driSupport = true;
  #   driSupport32Bit = true;
  #   extraPackages = with pkgs; [
  #     vaapiVdpau
  #     libvdpau-va-gl
  #   ];
  # };


  age.secrets = let 
    user = {
      owner = "gipphe";
      group = "gipphe";
      mode = "400";
    };
    hosts = ["nixos-vm"];
    keys = ["github" "gitlab" "codeberg"];
    suffixes = [".ssh" ".ssh.pub"];
    keyNames = lib.lists.crossLists (x: y: "${x}${y}") keys suffixes;
    inherit (builtins) foldl';
    secrets = foldl'
      (l: r: l // (
        foldl'
	  (l': r': l' // {
	    "${r'}-${r}" = {
	      file = ../../secrets/${r'}-${r}.age; 
	      path = "/home/gipphe/.ssh/${r}"; 
	    } // user; 
	  })
	  {}
	  hosts
      ))
      {}
      keyNames;
  in secrets;
  #{

    # "nixos-vm-github.ssh.age" = {
    #   file = ../../secrets/nixos-vm-github.ssh.age;
    #   path = "/home/gipphe/.ssh/github.ssh";
    # } // user;
    # "nixos-vm-gitlab.ssh.age" = {
    #   file = ../../secrets/nixos-vm-gitlab.ssh.age;
    #   path = "/home/gipphe/.ssh/gitlab.ssh";
    # } // user;
    # "nixos-vm-codeberg.ssh.age" = {
    #   file = ../../secrets/nixos-vm-codeberg.ssh.age;
    #   path = "/home/gipphe/.ssh/codeberg.ssh";
    # } // user;
  #};
}
