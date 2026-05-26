{
  pkgs,
  wlib,
  config,
  lib,
  ...
}:
{
  imports = [ wlib.modules.default ];
  options.settings = lib.mkOption {
    type = lib.types.lines;
    default = "";
    description = "Configuration for Mangohud";
  };
  config.constructFiles.generated_config = {
    relPath = "./config.conf";
    content = config.settings;
  };
  config.package = pkgs.mangohud;
  config.env.MANGOHUD_CONFIGFILE = "${placeholder "out"}/config.conf";
}
