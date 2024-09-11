{
  lib,
  util,
  config,
  ...
}:
util.mkModule {
  options.gipphe.programs.eza.enable = lib.mkEnableOption "eza";
  hm = lib.mkIf config.gipphe.programs.eza.enable {
    programs.eza = {
      enable = true;
      icons = true;
      git = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };
  };
}
