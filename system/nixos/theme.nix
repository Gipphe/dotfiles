{ flags, inputs, ... }:
{
  imports = [ inputs.catppuccin.nixosModules.catppuccin ];
  catppuccin = {
    enable = !flags.stylix.enable;
    flavor = "macchiato";
  };
}
