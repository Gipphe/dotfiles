{ utils, pkgs, ... }:
{
  imports = [ (utils.mkSimpleProgram "curl" pkgs.curlFull) ];
}
