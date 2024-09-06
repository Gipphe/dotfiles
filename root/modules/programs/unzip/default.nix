{ util, pkgs, ... }:
{
  imports = [ (util.mkSimpleProgram "unzip" pkgs.unzip) ];
}
