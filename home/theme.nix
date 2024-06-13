{ flags, ... }:
{
  catppuccin = {
    enable = !flags.stylix.enable;
    flavor = "macchiato";
  };
}
