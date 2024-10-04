{ lib, ... }:
{
  options.windows = {
    enable = lib.mkEnableOption "Windows Powershell setup script";

    chocolatey.programs = lib.mkOption {
      description = "Programs to add from Chocolatey.";
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "vscode"
        "Everything"
      ];
    };
    scoop = {
      buckets = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Additional buckets to add.";
        default = [ ];
        example = [ "extras" ];
      };
      programs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Programs to add from Scoop.";
        default = [ ];
        example = [ "direnv" ];
      };
    };
  };
}
