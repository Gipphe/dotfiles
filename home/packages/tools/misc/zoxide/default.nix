{ lib, config, ... }:
{
  options.gipphe.programs.zoxide.enable = lib.mkEnableOption "zoxide";
  config = lib.mkIf config.gipphe.programs.zoxide.enable {
    zoxide = {
      enable = true;
      options = [
        "--cmd"
        "cd"
      ];
    };
  };
}
