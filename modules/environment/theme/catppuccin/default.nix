{ inputs, util, ... }:
let
  config = {
    catppuccin = {
      enable = true;
      flavor = "macchiato";
    };
  };
in
util.mkToggledModule
  [
    "environment"
    "theme"
  ]
  {
    name = "catppuccin";

    hm = {
      imports = [ inputs.catppuccin.homeModules.catppuccin ];
      inherit config;
    };

    system-nixos = {
      imports = [ inputs.catppuccin.nixosModules.catppuccin ];
      inherit config;
    };
  }
