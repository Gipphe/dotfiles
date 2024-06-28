{ osConfig, ... }:
{
  stylix = {
    inherit (osConfig.stylix) base16Scheme;
  };
}
