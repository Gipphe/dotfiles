{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.mods.enable {
    home.packages = [ pkgs.mods ];
    xdg.configFile."mods/mods.yml".source = ./mods.yaml;
    programs.fish.shellInit = ''
      if test -f $XDG_CONFIG_HOME/mods/key
        set -gx MODS_OPENAI_API_KEY $(cat $XDG_CONFIG_HOME/mods/key)
      end
    '';
  };
}
