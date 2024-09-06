{ util, pkgs, ... }:
{
  imports = [ (util.mkSimpleProgram "make" pkgs.gnumake) ];
}
