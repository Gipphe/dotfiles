{ lib, ... }:
{
  options.gipphe.programs.fish = {
    enable = lib.mkEnableOption "fish";
    prompt = lib.mkOption {
      description = "Which prompt to use";
      type = lib.types.enum [
        "tide"
        "starship"
      ];
      default = "starship";
      example = "tide";
    };
  };
}
