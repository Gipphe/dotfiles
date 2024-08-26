{ inputs, util, ... }:
util.mkToggledModule
  [
    "environment"
    "theme"
  ]
  {
    name = "catppuccin";

    hm.imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];

    system-nixos.imports = [ inputs.catppuccin.nixosModules.catppuccin ];

    shared.catppuccin = {
      enable = true;
      flavor = "macchiato";
    };
  }
