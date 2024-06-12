{ inputs, ... }:
{
  imports = [ inputs.catppuccin.nixosModules.default ];
  catppuccin = {
    enable = false;
    flavor = "macchiato";
  };
}
