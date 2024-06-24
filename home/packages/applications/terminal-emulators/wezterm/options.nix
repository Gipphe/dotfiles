{ lib, ... }:
{
  options.gipphe.programs.wezterm.enable = lib.mkEnableOption "wezterm";
}
