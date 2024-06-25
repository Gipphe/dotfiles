{ lib, ... }:
{
  options.gipphe.programs.appimage.enable = lib.mkEnableOption "appimage bindings to make them executable";
}
