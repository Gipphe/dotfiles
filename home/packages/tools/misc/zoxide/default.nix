{ lib, config, ... }:
{
  options.gipphe.programs.zoxide.enable = lib.mkEnableOption "zoxide";
  config = lib.mkIf config.gipphe.programs.zoxide.enable {
    programs.zoxide = {
      enable = true;
      options = [
        "--cmd"
        "cd"
      ];
    };
  };
}
