{ lib, config, ... }:
{
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
