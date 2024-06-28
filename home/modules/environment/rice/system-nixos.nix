{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [ inputs.stylix.nixosModules.stylix ];
  config = lib.mkIf config.gipphe.environment.rice.enable {
    stylix.cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
  };
}
