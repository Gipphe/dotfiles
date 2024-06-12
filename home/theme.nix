{ flags, ... }:
{
  catppuccin = {
    enable = !flags.aux.stylix;
    flavor = "macchiato";
  };
}
