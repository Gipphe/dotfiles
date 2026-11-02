{
  den.aspects.programs.nix.gc.nixos = {
    nix.gc = {
      automatic = true;
      options = "--delete-older-than 8d";
      dates = "weekly";
    };
  };
}
