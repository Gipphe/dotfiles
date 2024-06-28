{ utils, pkgs, ... }:
{
  imports = [ (utils.mkSimpleProgram "make" pkgs.gnumake) ];
}
