{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.programs.gpg.enable {
    programs.gnupg.agent = {
      enable = true;
    };
  };
}
