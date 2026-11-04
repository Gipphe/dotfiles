{ inputs, ... }: {
  den.aspects.environment.catppuccin = {
    homeManager = {
      imports = [ inputs.catppuccin.homeModules.catppuccin ];
      catppuccin = {
        enable = true;
        autoEnable = true;
        accent = "sapphire";
        flavor = "macchiato";
      };
    };
    nixos = {
      imports = [ inputs.catppuccin.nixosModules.catppuccin ];
      catppuccin = {
        enable = true;
        autoEnable = true;
        accent = "sapphire";
        flavor = "macchiato";
      };
    };
  };
}
