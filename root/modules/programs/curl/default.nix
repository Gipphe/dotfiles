{ util, pkgs, ... }:
{
  imports = [ (util.mkSimpleProgram "curl" pkgs.curlFull) ];
}
