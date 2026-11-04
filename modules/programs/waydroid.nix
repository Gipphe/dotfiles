{
  den.aspects.programs.waydroid.nixos = { pkgs, ... }: {
    virtualisation.waydroid.enable = true;
    # For sharing clipboard
    environment.systemPackages = [ pkgs.wl-clipboard ];
  };
}
