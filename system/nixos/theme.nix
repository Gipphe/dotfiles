{ flags, inputs, ... }:
{
  imports = [ inputs.catppuccin.nixosModules.catppuccin ];
  catppuccin = {
    enable = !flags.aux.stylix;
    flavor = "macchiato";
  };
}
