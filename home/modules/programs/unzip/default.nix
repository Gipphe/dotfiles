{ utils, pkgs, ... }:
{
  imports = [ (utils.mkSimpleProgram "unzip" pkgs.unzip) ];
}
