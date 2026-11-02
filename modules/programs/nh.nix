{
  den.aspects.programs.nh = {
    nixos.programs.nh = {
      enable = true;
      flake = "/home/gipphe/projects/dotfiles";
    };
    gc.nixos = {
      programs.nh.clean = {
        enable = true;
        extraArgs = "--optimise --nogcroots --keep 3 --keep-since 8d";
        dates = "weekly";
      };
    };
  };
}
