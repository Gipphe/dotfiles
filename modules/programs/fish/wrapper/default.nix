{
  config,
  wlib,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    wlib.modules.default
    ./binds.nix
    ./completions.nix
    ./config.nix
    ./functions.nix
    ./plugins.nix
  ];

  options.configDir = lib.mkOption {
    type = lib.types.str;
    default = "user";
    internal = true;
  };

  config = {
    package = lib.mkDefault pkgs.fish;
    env.__fish_config_dir = "${placeholder "out"}/${config.configDir}";
    meta.maintainers = [ lib.maintainers.gipphe ];
    meta.description.pre = ''
      If you use this module with home-manager and pass
      `completions.packages`, it is highly suggested to also enable
      `programs.man.generateCaches`.
    '';
  };
}
